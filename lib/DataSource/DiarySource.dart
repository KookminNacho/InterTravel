import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../Model/Diary.dart';

class DiarySource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<Diary>> getDiaries(String userID) async {
    List<Diary> diaries = [];
    QuerySnapshot<Map<String, dynamic>> response = await firestore
        .collection('Diaries')
        .where('owner', isEqualTo: userID)
        .get();

    var futures = response.docs.map((doc) async {
      try {
        var data = doc.data();
        List<String> url = List<String>.from(data['image']);

        GeoPoint location = data['location'];
        NLatLng nLatLng = NLatLng(location.latitude, location.longitude);
        DateTime date = (data['date'] as Timestamp).toDate();

        return Diary(
          uid: doc.id,
          title: data['title'],
          content: data['content'],
          date: date,
          location: nLatLng,
          imageURI: url,
          owner: data['owner'],
          userID: data['userID'],
          address: data['address'],
        );
      } catch (e) {
        print(e);
        return null; // Return null in case of error
      }
    }).toList();

    // Filter out null values
    List<Future<Diary?>> nonNullFutures = futures.where((future) => future != null).toList();

    var results = await Future.wait(nonNullFutures);
    diaries = results.where((diary) => diary != null).cast<Diary>().toList();
    return diaries;
  }

  Future<bool> addDiary(Diary diary, String user) async {
    try {
      await firestore.collection('Diaries').add({
        'title': diary.title,
        'content': diary.content,
        'date': Timestamp.fromDate(diary.date),
        'location': GeoPoint(diary.location.latitude, diary.location.longitude),
        'image': diary.imageURI,
        'owner': user,
        'address': diary.address,
      });
      print(
          "Diary added ${diary.title}, ${diary.content}, ${diary.date}, ${diary.location}, ${diary.imageURI}, ${diary.address}, $user");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateDiary(Diary diary) async {
    try {
      await firestore.collection('Diaries').doc(diary.uid).update({
        'title': diary.title,
        'content': diary.content,
        'date': Timestamp.fromDate(diary.date),
        'location': GeoPoint(diary.location.latitude, diary.location.longitude),
        'image': diary.imageURI,
        'owner': diary.owner,
        'address': diary.address,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteDiary(Diary selectedDiary) async {
    try {
      await firestore.collection('Diaries').doc(selectedDiary.uid).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> deleteAllDiaries() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection('Diaries').get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteImage(String image) async {
    try {
      await storage.refFromURL(image).delete();
    } catch (e) {
      print(e);
    }
  }
}
