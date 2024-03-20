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

  // void dummyDiaries() {
  //   diaries = [
  //     Diary(
  //       title: "Gyeongbokgung Palace",
  //       content:
  //           "Visiting Gyeongbokgung Palace was an unforgettable experience.",
  //       image: "placeholder.jpg",
  //       date: Timestamp(2024, 1),
  //       location: NLatLng(37.5781, 126.9768),
  //     ),
  //     Diary(
  //       title: "N Seoul Tower",
  //       content: "Visiting N Seoul Tower was an unforgettable experience.",
  //       image: "placeholder.jpg",
  //       date: DateTime(2023, 11, 11),
  //       location: NLatLng(37.5512, 126.9882),
  //     ),
  //     Diary(
  //       title: "Bukchon Hanok Village",
  //       content:
  //           "Visiting Bukchon Hanok Village was an unforgettable experience.",
  //       image: "placeholder.jpg",
  //       date: DateTime(2023, 4, 9),
  //       location: NLatLng(37.5824, 126.9830),
  //     ),
  //     Diary(
  //       title: "Jeonju Hanok Village",
  //       content:
  //           "Visiting Jeonju Hanok Village was an unforgettable experience.",
  //       image: "placeholder.jpg",
  //       date: DateTime(2023, 5, 2),
  //       location: NLatLng(35.8151, 127.1539),
  //     ),
  //     Diary(
  //       title: "Haeundae Beach",
  //       content: "Visiting Haeundae Beach was an unforgettable experience.",
  //       image: "placeholder.jpg",
  //       date: DateTime(2024, 2, 17),
  //       location: NLatLng(35.1587, 129.1604),
  //     ),
  //     Diary(
  //       title: "Gwanghwamun Square",
  //       content: "Visiting Gwanghwamun Square was an unforgettable experience.",
  //       image: "placeholder.jpg",
  //       date: DateTime(2023, 5, 18),
  //       location: NLatLng(37.5763, 126.9769),
  //     ),
  //     Diary(
  //       title: "Lotte World Tower",
  //       content: "Visiting Lotte World Tower was an unforgettable experience.",
  //       image: "placeholder.jpg",
  //       date: DateTime(2023, 12, 10),
  //       location: NLatLng(37.5139, 127.1028),
  //     ),
  //     Diary(
  //       title: "Bulguksa Temple",
  //       content: "Visiting Bulguksa Temple was an unforgettable experience.",
  //       image: "placeholder.jpg",
  //       date: DateTime(2023, 10, 29),
  //       location: NLatLng(35.7892, 129.3310),
  //     ),
  //     Diary(
  //       title: "Suncheon Bay National Garden",
  //       content:
  //           "Visiting Suncheon Bay National Garden was an unforgettable experience.",
  //       image: "placeholder.jpg",
  //       date: DateTime(2023, 12, 9),
  //       location: NLatLng(34.8806, 127.4888),
  //     ),
  //     Diary(
  //       title: "DMZ (Demilitarized Zone)",
  //       content:
  //           "Visiting DMZ (Demilitarized Zone) was an unforgettable experience.",
  //       image: "placeholder.jpg",
  //       date: DateTime(2023, 9, 4),
  //       location: NLatLng(37.9566, 126.6774),
  //     ),
  //   ];
  //   notifyListeners();
  // }

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
