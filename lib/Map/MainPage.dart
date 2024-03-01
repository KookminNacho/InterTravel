import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';

import '../Provider/UserData.dart';

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
      Provider.of<UserData>(context, listen: false).updateLocation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Main Page"),
        ),
        body: Center(
          child: Consumer<UserData>(builder: (context, user, child) {
            return Stack(
              children: [
                NaverMap(
                  onCameraIdle: () async {
                    print(await _controller.getCameraPosition());
                  },
                  options: NaverMapViewOptions(
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
                    _controller = mapController;
                    NCameraUpdate cameraUpdate =
                        NCameraUpdate.fromCameraPosition(
                            NCameraPosition(target: user.location, zoom: 15));
                    cameraUpdate.setAnimation(
                        animation: NCameraAnimation.fly,
                        duration: Duration(seconds: 3));

                    _controller.updateCamera(cameraUpdate);
                  },
                ),
              ],
            );
          }),
        ));
  }
}

String url =
    "https://api.mapbox.com/styles/v1/not-cho/clt6vrjb8003h01r5ehd8hty5/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoibm90LWNobyIsImEiOiJjbHQ2dm1waGgwZmxyMmlwdGhuNWV0M2tsIn0.Y0sUyqzlnX95y2Ogsj8qYQ";
