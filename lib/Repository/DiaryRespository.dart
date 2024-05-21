import 'dart:ffi';

import 'package:intertravel/DataSource/DiarySource.dart';

import '../Model/Diary.dart';

class DiaryRepository{

  DiarySource _diarySource = DiarySource();

  Future<List<Diary>> getDiaries(String userID) async {
    List<Diary> diaries = await _diarySource.getDiaries(userID);

    return diaries;
  }

  Future<bool> addDiary(Diary diary, String userId) async {
    bool result = await _diarySource.addDiary(diary, userId);
    return result;
  }

  Future<bool> updateDiary(Diary diary) async {

    return await _diarySource.updateDiary(diary);
  }

  Future<bool> deleteDiary(Diary selectedDiary) async {
    return await _diarySource.deleteDiary(selectedDiary);

  }
}