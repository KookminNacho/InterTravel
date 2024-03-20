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
    print("location: ${Provider.of<UserData>(context).location}");
    return Scaffold(
        body: Consumer<DiaryProvider>(builder: (context, diaries, child) {
      return Consumer<UserPermission>(builder: (context, permission, child) {
        return (permission.locationPermission)
            ? Consumer<UserData>(builder: (context, user, child) {
                mapLoaded(user, diaries);
                return (user.location == null)
                    ? Container(
                        color: Colors.black,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: const Center(child: CircularProgressIndicator()))
                    : Stack(
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
    print("Creating Overlays, Diary: $diary");
    Set<NAddableOverlay> overlays = Set();
    NLatLng? tempLocation = Provider.of<UserData>(context).location;
    if (tempLocation != null) {
      print("tempLocation: $tempLocation");
      overlays.add(NMarker(id: "temp", position: tempLocation));
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
      marker.setOnTapListener((overlay) {print("tapped: ${d.title} $overlay");});
      overlays.add(marker);
      print("title : ${d.title}");
    }
    print("Overlays: $overlays");

    return overlays;
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
        widget: ImagedMarker(diary: diary),
        size: Size(50, 50),
        context: context);
  }

  void mapLoaded(UserData user, DiaryProvider diaries) async {
    if (user.mapLoad) {
      _controller.addOverlayAll(await _createOverlays(diaries.diaries));
    }
  }
}

String url =
    "https://api.mapbox.com/styles/v1/not-cho/clt6vrjb8003h01r5ehd8hty5/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoibm90LWNobyIsImEiOiJjbHQ2dm1waGgwZmxyMmlwdGhuNWV0M2tsIn0.Y0sUyqzlnX95y2Ogsj8qYQ";
