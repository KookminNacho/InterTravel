import 'package:flutter/cupertino.dart';
import 'package:intertravel/DataSource/DiarySource.dart';

import '../Model/Diary.dart';

class DiaryRepository{

  DiarySource _diarySource = DiarySource();

  Future<List<Diary>> getDiaries(String userID) async {
    print("DiaryRepository getDiaries");
    List<Diary> diaries = await _diarySource.getDiaries(userID);

    return diaries;
  }
}