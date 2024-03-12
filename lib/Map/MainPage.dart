import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intertravel/Profile/LoginPage.dart';
import 'package:intertravel/WelcomePage.dart';
import 'package:provider/provider.dart';

import '../GlobalPageRoute.dart';
import '../Provider/ImageProvider.dart';
import '../Provider/UserData.dart';
import '../Util/Constrains.dart';
import 'Diary.dart';

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
      Provider.of<UserData>(context, listen: false).dummyDiaries();
      await Provider.of<UserData>(context, listen: false).getLocation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("location: ${Provider.of<UserData>(context).location}");
    return Scaffold(body: Consumer<UserData>(builder: (context, user, child) {
      // mapLoaded(user);
      return (user.location == null)
          ? CircularProgressIndicator()
          : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                NaverMap(
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
                          target:
                              NLatLng(35.95667374781408, 127.85881633921491),
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
    }));
  }

  Future<Set<NAddableOverlay<NOverlay<void>>>> _createOverlays(
      List<Diary> diary) async {
    Set<NAddableOverlay> overlays = Set();
    NLatLng? tempLocation = Provider.of<UserData>(context).location;
    if (tempLocation != null) {
      print("tempLocation: $tempLocation");
      overlays.add(NMarker(
          id: "test", position: tempLocation));
    } else {
      print("tempLocation is null");
    }
    for (Diary d in diary) {
      print("Diary: $d");
      overlays.add(NMarker(
        id: d.title,
        position: d.location,
      ));
    }
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

  Future<NOverlayImage> markerWithImage(Map<String, Image> images) async {
    return NOverlayImage.fromWidget(
        widget: Column(
          children: [
            Container(
                height: 40,
                width: 48,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: images["https://picsum.photos/200/300"]!
            ),
          Container(
              color: Colors.grey,
              height: 4,
              width: 2,
            )
          ],
        ),
        size: Size(50, 50),
        context: context);
  }

  void mapLoaded(UserData user) async {
    Provider.of<ImageProviderModel>(context, listen: false)
        .loadImage("https://picsum.photos/200/300");
    if (user.mapLoad) {
      NCameraUpdate cameraUpdate = NCameraUpdate.fromCameraPosition(
          NCameraPosition(target: user.location!, zoom: 15));
      cameraUpdate.setAnimation(
          animation: NCameraAnimation.fly, duration: Duration(seconds: 3));
      _controller.addOverlayAll(await _createOverlays(user.diaries));
      _controller.updateCamera(cameraUpdate);
    }
  }
}

String url =
    "https://api.mapbox.com/styles/v1/not-cho/clt6vrjb8003h01r5ehd8hty5/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoibm90LWNobyIsImEiOiJjbHQ2dm1waGgwZmxyMmlwdGhuNWV0M2tsIn0.Y0sUyqzlnX95y2Ogsj8qYQ";
