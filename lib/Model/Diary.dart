import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class Diary {
  String title;
  String content;
  String image;
  DateTime date;
  NLatLng location;

  Diary(
      {this.title = "",
      this.content = "",
      this.image = "",
      required this.date,
      required this.location}) {
    date = DateTime.now();
  }
}
