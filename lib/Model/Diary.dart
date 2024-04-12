import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter/material.dart';

class Diary {
  String title;
  String content;
  List<String> image;
  DateTime date;
  NLatLng location;
  String owner;
  String userID;
  List<String> imageURI;

  Diary(
      {this.title = "",
      this.content = "",
      required this.image,
      required this.date,
      required this.location,
      this.owner = "",
      this.userID = "",
      this.imageURI = const []}) {
    date = DateTime.now();
  }
}
