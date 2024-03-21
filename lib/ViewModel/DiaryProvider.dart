import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intertravel/Repository/DiaryRespository.dart';

import '../Model/Diary.dart';

class DiaryProvider with ChangeNotifier {
  List<Diary> _diary = [];

  List<Diary> get diaries => _diary;


  // 일기를 불러오는 메소드
  Future<void> loadDiary() async {
    DiaryRepository diaryRepository = DiaryRepository();
    _diary = await diaryRepository.getDiaries();
    notifyListeners();
  }

}