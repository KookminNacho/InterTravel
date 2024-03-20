import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../Model/Diary.dart';

class DiarySource {
  Future<List<Diary>> getDiaries() async {
    List<Diary> diaries = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> response =
        await firestore.collection('Diaries').get();
    for (var doc in response.docs) {
      GeoPoint location = doc['location'];
      NLatLng nLatLng = NLatLng(location.latitude, location.longitude);
      print(doc.data());
      diaries.add(Diary(
        title: doc['title'],
        content: doc['content'],
        date: doc['date'],
        location: nLatLng,
        image: doc['image'],
      ));
    }
    // Fetch data from the server
    return diaries;
  }
}
