import 'package:intertravel/DataSource/DiarySource.dart';

import '../Model/Diary.dart';

class DiaryRepository{

  DiarySource _diarySource = DiarySource();

  Future<List<Diary>> getDiaries() async {
    print("DiaryRepository getDiaries");
    return await _diarySource.getDiaries();
  }
}