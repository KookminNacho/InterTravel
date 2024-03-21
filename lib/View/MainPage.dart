import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
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
                        onSymbolTapped: (nMapSymbol) {
                          print(nMapSymbol.caption);
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

  Widget imagedMarker(Diary diary, Size size) {
    return Container(
      color: Colors.blue,
      child: AnimatedContainer(
        height: size.height,
        duration: Duration(milliseconds: 300),
        child: Column(
          children: [
            Container(
                height: size.height - 4,
                width: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Text(
                  diary.title,
                  style: const TextStyle(color: Colors.black, fontSize: 10),
                )),
            Container(
              color: Colors.grey,
              height: 4,
              width: 2,
            )
          ],
        ),
      ),
    );
  }

  Future<Set<NAddableOverlay<NOverlay<void>>>> _createOverlays(
      List<Diary> diary) async {
    print("Creating Overlays, Diary: $diary");
    NLatLng? tempLocation = Provider.of<UserData>(context).location;
    if (tempLocation != null) {
      print("tempLocation: $tempLocation");
      MarkerManager.overlays.add(NMarker(id: "temp", position: tempLocation));
    } else {
      print("tempLocation is null");
    }
    for (Diary d in diary) {
      print(d.location);
      NMarker marker = NMarker(
        id: d.title,
        position: d.location,
        icon: await markerWithImage(d),
      );
      marker.setOnTapListener((overlay) async {
        print("tapped: ${d.title} $overlay");
        final infoWindow = NInfoWindow.onMap(
            id: "test", position: overlay.position, text: "인포윈도우 텍스트");
        NCameraUpdate move = NCameraUpdate.scrollAndZoomTo(
            target: NLatLng(d.location.latitude, d.location.longitude),
            zoom: 14);
        move.setAnimation(
            animation: NCameraAnimation.fly,
            duration: const Duration(milliseconds: 1500));
        setState(() {
          _controller.updateCamera(move);
        });
      });
      MarkerManager.overlays.add(marker);
      MarkerManager.size[d.title] = 50;
      print("title : ${d.title}");
    }

    return MarkerManager.overlays;
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

  Future<NOverlayImage> markerWithImage(Diary diary) async {
    return NOverlayImage.fromWidget(
        widget: imagedMarker(diary, Size(50, 50)),
        size: Size(50, 50),
        context: context);
  }

  void mapLoaded(UserData user, DiaryProvider diaries) async {
    if (user.mapLoad) {
      _controller.addOverlayAll(await _createOverlays(diaries.diaries));
    }
  }
}
