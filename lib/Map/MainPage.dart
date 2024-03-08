import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intertravel/Profile/LoginPage.dart';
import 'package:intertravel/WelcomePage.dart';
import 'package:provider/provider.dart';

import '../GlobalPageRoute.dart';
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
      mapLoaded(user);
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

  Set<NAddableOverlay> _createOverlays(List<Diary> diary) {
    print("createOverlays: $diary");
    Set<NAddableOverlay> overlays = Set();
    NLatLng? tempLocation = Provider.of<UserData>(context).location;
    if (tempLocation != null) {
      print("tempLocation: $tempLocation");
      overlays.add(NMarker(id: "test", position: tempLocation));
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

  void mapLoaded(UserData user){
    if(user.mapLoad){
      NCameraUpdate cameraUpdate =
      NCameraUpdate.fromCameraPosition(
          NCameraPosition(target: user.location!, zoom: 15));
      cameraUpdate.setAnimation(
          animation: NCameraAnimation.fly,
          duration: Duration(seconds: 3));
      _controller.addOverlayAll(_createOverlays(user.diaries));
      _controller.updateCamera(cameraUpdate);
    }
  }
}

String url =
    "https://api.mapbox.com/styles/v1/not-cho/clt6vrjb8003h01r5ehd8hty5/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoibm90LWNobyIsImEiOiJjbHQ2dm1waGgwZmxyMmlwdGhuNWV0M2tsIn0.Y0sUyqzlnX95y2Ogsj8qYQ";
