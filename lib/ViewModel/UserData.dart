import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intertravel/Repository/AuthRepository.dart';
import '../Model/Diary.dart';

class UserData extends ChangeNotifier {
  NLatLng? _location;
  bool _mapLoad = false;
  UserCredential? _user;
  String _uid = "";
  String _displayName = "";
  Image _photo = Image.asset("assets/images/user.png");

  NLatLng? get location => _location;

  bool get mapLoad => _mapLoad;

  UserCredential? get user => _user;

  String get uid => _uid;

  String get displayName => _displayName;

  Image get photo => _photo;


  set user(UserCredential? value) {
    _user = value;
    if (user?.user?.uid != null) {
      _uid = user!.user!.uid;
    }
    if (user?.user?.displayName != null) {
      _displayName = user!.user!.displayName!;
    }
    notifyListeners();
  }

  set mapLoad(bool value) {
    print("MapLoad changed: $value");
    _mapLoad = value;
    notifyListeners();
  }

  set location(NLatLng? value) {
    _location = value;
    print("Location: $_location");
    notifyListeners();
  }

  void updateLocation() {
    Geolocator.getPositionStream().listen((Position position) {
      location = NLatLng(position.latitude, position.longitude);
      notifyListeners();
    });
  }

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      location = NLatLng(position.latitude, position.longitude);
      notifyListeners();
    } catch (e) {
      print("Error getting location: $e");
      location = null; // 에러 발생 시 위치 정보를 null로 설정
      notifyListeners();
    }
  }

  set photo(Image value) {
    _photo = value;
    notifyListeners();
  }
}
