import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

class UserData extends ChangeNotifier {
  late NLatLng _location;

  NLatLng get location => _location;

  set location(NLatLng value) {
    _location = value;
    print("LLocation: $_location");
    notifyListeners();
  }

  void updateLocation() {
    Geolocator.getPositionStream().listen((Position position) {
      location = NLatLng(position.latitude, position.longitude);
      notifyListeners();
    });
  }
}
