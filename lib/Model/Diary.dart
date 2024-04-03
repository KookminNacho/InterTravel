import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter/material.dart';

class Diary {
  String title;
  String content;
  String image;
  DateTime date;
  NLatLng location;
  String owner;
  String userID;
  String imageURI;
  late Image imageFile;

  Diary(
      {this.title = "",
      this.content = "",
      this.image = "",
      required this.date,
      required this.location,
      this.owner = "",
      this.userID = "",
      this.imageURI = ""}) {
    date = DateTime.now();
  }

  void setImageFile(Image image) {
    imageFile = image;
  }
}
