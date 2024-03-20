import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intertravel/Repository/AuthRepository.dart';
import '../Model/Diary.dart';

class UserData extends ChangeNotifier {
  NLatLng? _location;
  List<Diary> diaries = [];
  bool _mapLoad = false;
  UserCredential? _user;
  String _uid = "";
  String _displayName = "";

  NLatLng? get location => _location;

  List<Diary> get diary => diaries;

  bool get mapLoad => _mapLoad;

  UserCredential? get user => _user;

  String get uid => _uid;

  set user (UserCredential? value) {
    _user = value;
    if(user?.user?.uid != null) {
      _uid = user!.user!.uid;
    }
    if(user?.user?.displayName != null) {
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

  set diary(List<Diary> value) {
    diaries = value;
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
}
