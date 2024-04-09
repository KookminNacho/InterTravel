import 'dart:typed_data';

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

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Provider.of<UserData>(context, listen: false).getLocation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<UserData>(context, listen: false).getLocation();
    print("location: ${Provider.of<UserData>(context).location}");
    return Scaffold(
        body: Consumer<DiaryProvider>(builder: (context, diaries, child) {
      return Consumer<UserPermission>(builder: (context, permission, child) {
        return (permission.locationPermission)
            ? Consumer<UserData>(builder: (context, user, child) {
                mapLoaded(user, diaries);
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
                        onCameraChange: (position, isGesture) {
                          print("Camera changed: $position");
                          if (!isGesture) {
                            _controller.addOverlayAll(
                                Provider.of<MarkerManager>(context,
                                        listen: false)
                                    .markers);
                          }
                        },
                        onCameraIdle: () async {
                          print(await _controller.getCameraPosition());
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
                          print("mapLoad: ${user.mapLoad}");

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
    print("Creating Overlays, Diary: $diary");
    NLatLng? tempLocation =
        Provider.of<UserData>(context, listen: false).location;
    if (tempLocation != null) {
      print("tempLocation: $tempLocation");
      markerManager.addMarker(NMarker(id: "temp", position: tempLocation));
      _controller.updateCamera(NCameraUpdate.fromCameraPosition(
          NCameraPosition(target: tempLocation, zoom: 7)));
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

  // Future<void> preloadImages(List<String> imageUrls) async {
  //   final List<Future> imagePreloadFutures = [];
  //
  //   for (String url in imageUrls) {
  //     final ImageProvider.dart imageProvider = NetworkImage(url);
  //     final Future preloadFuture = precacheImage(imageProvider, context);
  //     imagePreloadFutures.add(preloadFuture);
  //   }
  //
  //   await Future.wait(imagePreloadFutures);
  // }

  Future<Image> loadImage(Diary diary) async {
    return Image.network(diary.image);
  }

  Future<NOverlayImage> markerWithImage(Diary diary) async {
    Uint8List image = Provider.of<ImageProviderModel>(context, listen: false)
        .images[diary.imageURI]!;

    return NOverlayImage.fromByteArray(image);
  }

  void mapLoaded(UserData user, DiaryProvider diaries) async {
    if (user.mapLoad) {
      await Provider.of<ImageProviderModel>(context, listen: false)
          .loadImages(diaries.diaries);
      _controller.addOverlayAll(await _createOverlays(diaries.diaries));
    }
  }
}
