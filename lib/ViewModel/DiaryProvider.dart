import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intertravel/Repository/DiaryRespository.dart';
import 'package:intertravel/Repository/ImageRepository.dart';

import '../Model/Diary.dart';

class DiaryProvider with ChangeNotifier {
  bool _isLoaded = false;
  List<Diary> _diary = [];
  Diary? _selectedDiary;

  bool get isLoaded => _isLoaded;

  List<Diary> get diaries => _diary;

  Diary? get selectedDiary => _selectedDiary;

  // 일기를 불러오는 메소드
  Future<void> loadDiary(String userID) async {
    DiaryRepository diaryRepository = DiaryRepository();
    _diary = await diaryRepository.getDiaries(userID);
    _isLoaded = true;
    notifyListeners();
  }

  // 일기를 선택하는 메소드
  void selectDiary(Diary? diary) {
    _selectedDiary = diary;
    notifyListeners();
  }

  // 불러온 일기를 초기화하는 메소드
  Future<void> clearDiary() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _diary = [];
    _isLoaded = false;
    notifyListeners();
  }
}
