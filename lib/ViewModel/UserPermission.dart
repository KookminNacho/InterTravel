import "package:flutter/material.dart";
import "package:permission_handler/permission_handler.dart";

class UserPermission extends ChangeNotifier {
  bool _locationPermission = false;

  UserPermission() {
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    _locationPermission = await Permission.location.isGranted;
    print("Location Permission: $_locationPermission");
    notifyListeners();
  }

  Future<void> requestLocationPermission() async {
    await Permission.location.request();
    _locationPermission = await Permission.location.isGranted;
    notifyListeners();
  }

  bool get locationPermission => _locationPermission;
}
