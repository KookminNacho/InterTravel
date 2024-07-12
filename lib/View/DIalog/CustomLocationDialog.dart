import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intertravel/DataSource/NaverGeoCoder.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../ViewModel/UserData.dart';

class CustomLocationDialog extends StatefulWidget {
  const CustomLocationDialog({Key? key}) : super(key: key);

  @override
  State<CustomLocationDialog> createState() => _CustomLocationDialogState();
}

class _CustomLocationDialogState extends State<CustomLocationDialog> {
  late NaverMapController _naverMapController;
  final ValueNotifier<String?> _cameraPosition = ValueNotifier<String?>(null);
  Timer? _debounce;

  Future<void> _updateCameraPosition() async {
    final position = await NaverGeoCoder.getCityName(
        _naverMapController.nowCameraPosition.target);
    _cameraPosition.value = position;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _cameraPosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserData>(
      builder: (context, userData, child) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 50,
                child: BackButton(onPressed: () => Navigator.pop(context)),
              ),
              const Text("위치 설정"),
              Container(width: 50),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<String?>(
                valueListenable: _cameraPosition,
                builder: (context, value, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("지도 위치", style: TextStyle(fontSize: 20),),
                        Text(
                          value ?? "로딩 중...",
                          style: const TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 400,
                width: 300,
                child: Stack(
                  children: [
                    NaverMap(
                      onCameraIdle: () {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce =
                            Timer(const Duration(milliseconds: 500), () {
                          _updateCameraPosition();
                        });
                      },
                      options: NaverMapViewOptions(
                        initialCameraPosition: NCameraPosition(
                          target:
                              userData.selectedLocation ?? userData.location!,
                          zoom: 15,
                        ),
                      ),
                      onMapReady: (controller) {
                        _naverMapController = controller;
                        _updateCameraPosition();
                      },
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Icon(Icons.location_pin, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: MaterialButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  userData.selectedLocation =
                      _naverMapController.nowCameraPosition.target;
                  Navigator.pop(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      const Text("여기로 위치 변경하기", style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
