import 'package:flutter_naver_map/flutter_naver_map.dart';

class Diary {
  String uid;
  String title;
  String content;
  DateTime date;
  NLatLng location;
  String owner;
  String? userID;
  List<String> imageURI;

  Diary(
      {required this.uid,
      this.title = "",
      this.content = "",
      required this.date,
      required this.location,
      required this.owner,
      this.userID = "",
      this.imageURI = const []}) {}
}
