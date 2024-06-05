import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intertravel/DataSource/NaverGeoCoder.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/UserData.dart';

class CustomLocationDialog extends StatefulWidget {
  const CustomLocationDialog({super.key});

  @override
  State<CustomLocationDialog> createState() => _CustomLocationDialogState();
}

class _CustomLocationDialogState extends State<CustomLocationDialog> {
  late NaverMapController naverMapController;
  late Future<String?> cameraPosition;

  Future<String?> getCameraPosition() async {
    return NaverGeoCoder.getCityName(
        naverMapController.nowCameraPosition.target);
  }

  @override
  Widget build(BuildContext context) {
    cameraPosition = getCameraPosition();
    return Consumer<UserData>(builder: (context, userData, child) {
      return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 50,
                child: BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const Text("위치 설정"),
              Container(
                width: 50,
              )
            ],
          ),
          actions: [
            Column(
              children: [
                FutureBuilder<String?>(
                    future: cameraPosition,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                              text: TextSpan(
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                            children: [
                              const TextSpan(text: "지도 위치: "),
                              TextSpan(
                                  text: snapshot.data!,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          )),
                        );
                      }
                      return const CircularProgressIndicator();
                    }),
                SizedBox(
                    height: 400,
                    width: 300,
                    child: Stack(
                      children: [
                        NaverMap(
                            onCameraIdle: () {
                              setState(() {
                                cameraPosition = getCameraPosition();
                              });
                            },
                            options: NaverMapViewOptions(
                                initialCameraPosition: NCameraPosition(
                                    target: userData.location!, zoom: 15)),
                            onMapReady: (controller) {
                              setState(() {
                                naverMapController = controller;
                              });
                              naverMapController.updateCamera(
                                  NCameraUpdate.scrollAndZoomTo(
                                      target: userData.location!, zoom: 15));
                            }),
                        const Center(
                            child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Icon(
                            Icons.location_pin,
                            color: Colors.red,
                          ),
                        )),
                      ],
                    )),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: MaterialButton(
                    padding: const EdgeInsets.all(0),
                      onPressed: () {
                      userData.selectedLocation =
                          naverMapController.nowCameraPosition.target;
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical:8),
                        decoration: BoxDecoration(border: Border.all(color: Colors.black54, width: 0.5), borderRadius: BorderRadius.circular(10)),
                          child: const Text("여기로 위치 변경하기", style: TextStyle(fontSize: 16)))),
                ),
              ],
            )
          ]);
    });
  }
}
