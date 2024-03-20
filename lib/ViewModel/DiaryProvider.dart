import 'package:flutter/material.dart';
import 'package:intertravel/Repository/DiaryRespository.dart';

import '../Model/Diary.dart';

class DiaryProvider with ChangeNotifier {
  List<Diary> _diary = [];

  List<Diary> get diaries => _diary;

  // 일기를 불러오는 메소드
  Future<void> loadDiary() async {
    DiaryRepository diaryRepository = DiaryRepository();
    _diary = await diaryRepository.getDiaries();
    print("DiaryProvider loadDiary, ${_diary.length}개의 일기를 불러왔습니다.");
    notifyListeners();
  }
}