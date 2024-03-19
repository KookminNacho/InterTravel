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


class DiaryManager{
  List<Diary> diaries = [];


  void addDiary(Diary diary){
    diaries.add(diary);
  }

  void removeDiary(Diary diary){
    diaries.remove(diary);
  }

  void updateDiary(Diary diary, int index){
    diaries[index] = diary;
  }
}