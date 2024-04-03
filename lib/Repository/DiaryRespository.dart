import 'package:flutter/cupertino.dart';
import 'package:intertravel/DataSource/DiarySource.dart';

import '../Model/Diary.dart';
import 'ImageRepository.dart';

class DiaryRepository{

  DiarySource _diarySource = DiarySource();

  Future<List<Diary>> getDiaries() async {
    print("DiaryRepository getDiaries");
    List<Diary> diaries = await _diarySource.getDiaries();

    ImageRepository imageRepository = ImageRepository();
    await imageRepository.loadImages(diaries);
    return diaries;
  }
}