import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as IMG;

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intertravel/View/ImagedMarker.dart';
import 'package:intertravel/View/LoginPage.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:intertravel/ViewModel/UserPermission.dart';
import 'package:intertravel/WelcomePage.dart';
import 'package:provider/provider.dart';

import '../GlobalPageRoute.dart';
import '../Model/Diary.dart';
import '../Util/Constrains.dart';
import '../ViewModel/ImageProvider.dart';
import '../ViewModel/MarkerManager.dart';
import '../ViewModel/UserData.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late NaverMapController _controller;
  bool _isLoaded = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Provider.of<UserData>(context, listen: false).getLocation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _cameraMove = false;
    // Provider.of<UserData>(context, listen: false).getLocation();
    print("location: ${Provider.of<UserData>(context).location}");
    return Scaffold(
        body: Consumer<DiaryProvider>(builder: (context, diaries, child) {
      return Consumer<UserPermission>(builder: (context, permission, child) {
        return (permission.locationPermission)
            ? Consumer<UserData>(builder: (context, user, child) {
                if (!_isLoaded && diaries.isLoaded) {
                  mapLoad(user, diaries);
                }
                if (user.location == null) {
                  user.getLocation();
                  return Container(
                      color: Colors.black,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(child: CircularProgressIndicator()));
                } else {
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      NaverMap(
                        onCameraChange: (reason, isGesture) {
                          if (reason == NCameraUpdateReason.gesture) {
                            // print("cameraMove: $_cameraMove");
                          }
                        },
                        onCameraIdle: () async {
                          if (_cameraMove) {
                            // loadImage(diaries.selectedDiary!);
                            _cameraMove = false;
                          }
                        },
                        options: const NaverMapViewOptions(
                            extent: NLatLngBounds(
                              southWest: NLatLng(31.43, 122.37),
                              northEast: NLatLng(44.35, 132.0),
                            ),
                            minZoom: 6,
                            initialCameraPosition: NCameraPosition(
                                target: NLatLng(
                                    35.95667374781408, 127.85881633921491),
                                zoom: 6)),
                        onMapReady: (NaverMapController mapController) {
                          Future.delayed(Duration(milliseconds: 1000), () {
                            setState(() {
                              loginColor = Colors.black.withOpacity(0.5);
                              loginHeight = 0;
                            });
                          });
                          _controller = mapController;
                        },
                      ),
                      WelcomePage(),
                      LoginPage(),
                    ],
                  );
                }
              })
            : Center(
                child: ElevatedButton(
                    onPressed: () {
                      permission.requestLocationPermission();
                    },
                    child: Text("권한을 허용해주세요")),
              );
      });
    }));
  }

  Future<Set<NAddableOverlay<NOverlay<void>>>> _createOverlays(
      List<Diary> diary) async {
    MarkerManager markerManager =
        Provider.of<MarkerManager>(context, listen: false);
    NLatLng? tempLocation =
        Provider.of<UserData>(context, listen: false).location;
    if (tempLocation != null) {
      print("tempLocation: $tempLocation");
      markerManager.addMarker(NMarker(id: "temp", position: tempLocation));
    } else {
      print("tempLocation is null");
    }
    for (Diary d in diary) {
      NMarker marker = NMarker(
        id: d.title,
        position: d.location,
        icon: await markerWithImage(d),
      );

      marker.setOnTapListener((overlay) async {
        print("Marker tapped: ${d.title}");
        marker = NMarker(
          id: d.title,
          position: d.location,
          // icon: await biggerMarkerWithImage(d),
        );
        _controller.addOverlay(marker);
        NCameraUpdate move = NCameraUpdate.scrollAndZoomTo(
            target: NLatLng(d.location.latitude, d.location.longitude),
            zoom: 14);
        move.setAnimation(
            animation: NCameraAnimation.fly,
            duration: const Duration(milliseconds: 1500));
        _controller.updateCamera(move);
      });

      markerManager.addMarker(marker);

      print("title : ${d.title}");
    }

    return markerManager.markers;
  }

  Future<NOverlayImage> markerWithImage(Diary diary) async {
    Uint8List image = Provider.of<ImageProviderModel>(context, listen: false)
        .images[diary.imageURI]![0];

    return NOverlayImage.fromByteArray(image);
  }

  void mapLoad(UserData user, DiaryProvider diaries) async {
    print("마커 불러오기");
    ImageProviderModel imageProvider =
        Provider.of<ImageProviderModel>(context, listen: false);
    for (Diary d in diaries.diaries) {
      if (imageProvider.images[d.imageURI] == null) {
        await imageProvider.loadImage(d);
      }
      drawMarker(d, imageProvider);
    }
    _isLoaded = true;
  }

  void drawMarker(Diary d, ImageProviderModel imageProviderModel) async {
    Uint8List img = imageProviderModel.images[d.imageURI]![0];
    Uint8List bigimg = imageProviderModel.images[d.imageURI]![1];
    _controller.addOverlay(clickAbleMarker(d, [
      await NOverlayImage.fromByteArray(img),
      await NOverlayImage.fromByteArray(bigimg)
    ]));
  }

  NMarker clickAbleMarker(Diary diary, List<NOverlayImage> image) {
    NMarker marker =
        NMarker(id: diary.title, position: diary.location, icon: image[0]);
    marker.setOnTapListener((overlay) async {
      Provider.of<DiaryProvider>(context, listen: false).selectDiary(diary);
      marker = NMarker(
        id: diary.title,
        position: diary.location,
        icon: await image[1],
      );
      _controller.addOverlay(marker);
      NCameraUpdate move = NCameraUpdate.scrollAndZoomTo(
          target: NLatLng(diary.location.latitude, diary.location.longitude),
          zoom: 14);
      move.setAnimation(
          animation: NCameraAnimation.fly,
          duration: const Duration(milliseconds: 1500));
      _controller.updateCamera(move);
    });
    return marker;
  }
}
