import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intertravel/Map/Diary.dart';

class UserData extends ChangeNotifier {
  NLatLng? _location;
  List<Diary> diaries = [];

  NLatLng? get location => _location;

  List<Diary> get diary => diaries;

  set location(NLatLng? value) {
    _location = value;
    print("Location: $_location");
    notifyListeners();
  }

  set diary(List<Diary> value) {
    diaries = value;
    notifyListeners();
  }

  void dummyDiaries() {
    for (int i = 0; i < 10; i++) {
      diaries.add(Diary(
          title: "Title $i",
          content: "Content $i",
          location: NLatLng(37.5665 + i, 126.9780 + i),
          date: DateTime.now()));
    }
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
