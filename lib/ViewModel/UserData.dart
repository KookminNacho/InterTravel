import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';

class UserData extends ChangeNotifier {
  NLatLng? _location;
  NLatLng? _selectedLocation;
  bool _mapLoad = false;
  User? _user;
  String _uid = "";
  String _displayName = "";
  Image _photo = Image.asset("assets/images/user.png");

  NLatLng? get location => _location;

  NLatLng? get selectedLocation => _selectedLocation;

  bool get mapLoad => _mapLoad;

  User? get user => _user;

  String get uid => _uid;

  String get displayName => _displayName;

  Image get photo => _photo;




  set user(User? value) {
    _user = value;
    if (user?.uid != null) {
      _uid = user!.uid;
    }
    if (user?.displayName != null) {
      _displayName = user!.displayName!;
    }
    if(user?.photoURL != null) {
      _photo = Image.network(user!.photoURL!);
    }
    notifyListeners();
  }

  void autoLogin() {
    if(FirebaseAuth.instance.currentUser != null) {
      user = FirebaseAuth.instance.currentUser;
      print("Auto login: ${user!.displayName}");
    }
    else{
      print("Auto login failed");
    }


  }

  void signOut(DiaryProvider diaryProvider) {
    FirebaseAuth.instance.signOut();
    diaryProvider.clearDiary();
    user = null;
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

  set selectedLocation(NLatLng? value) {
    _selectedLocation = value;
    notifyListeners();
  }

  set photo(Image value) {
    _photo = value;
    notifyListeners();
  }
}
