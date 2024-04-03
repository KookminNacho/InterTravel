import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../Model/Diary.dart';

class DiarySource {
  Future<List<Diary>> getDiaries() async {
    List<Diary> diaries = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> response =
        await firestore.collection('Diaries').get();
    for (var doc in response.docs) {
      String url = await FirebaseStorage.instance
          .refFromURL(doc['image'])
          .getDownloadURL();
      GeoPoint location = doc['location'];
      NLatLng nLatLng = NLatLng(location.latitude, location.longitude);
      Timestamp tdate = doc['date'];
      DateTime date = tdate.toDate();
      print(doc.data());
      diaries.add(Diary(
        title: doc['title'],
        content: doc['content'],
        date: date,
        location: nLatLng,
        image: doc['image'],
        imageURI: url,
        owner: doc['owner'],

      ));
    }
    // Fetch data from the server
    return diaries;
  }

  void addDiary() async {
    print("Adding diaries");

    List diaries = [
      Diary(
          title: "Gyeongbokgung Palace",
          content:
              "Visiting Gyeongbokgung Palace was an unforgettable experience.",
          image: "placeholder.jpg",
          date: DateTime(2024, 1),
          location: NLatLng(37.5781, 126.9768),
          owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02"),
      Diary(
          title: "N Seoul Tower",
          content: "Visiting N Seoul Tower was an unforgettable experience.",
          image: "placeholder.jpg",
          date: DateTime(2023, 11, 11),
          location: NLatLng(37.5512, 126.9882),
          owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02"),
      Diary(
          title: "Bukchon Hanok Village",
          content:
              "Visiting Bukchon Hanok Village was an unforgettable experience.",
          image: "placeholder.jpg",
          date: DateTime(2023, 4, 9),
          location: NLatLng(37.5824, 126.9830),
          owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02"),
      Diary(
          title: "Jeonju Hanok Village",
          content:
              "Visiting Jeonju Hanok Village was an unforgettable experience.",
          image: "placeholder.jpg",
          date: DateTime(2023, 5, 2),
          location: NLatLng(35.8151, 127.1539),
          owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02"),
      Diary(
          title: "Haeundae Beach",
          content: "Visiting Haeundae Beach was an unforgettable experience.",
          image: "placeholder.jpg",
          date: DateTime(2024, 2, 17),
          location: NLatLng(35.1587, 129.1604),
          owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02"),
      Diary(
          title: "Gwanghwamun Square",
          content:
              "Visiting Gwanghwamun Square was an unforgettable experience.",
          image: "placeholder.jpg",
          date: DateTime(2023, 5, 18),
          location: NLatLng(37.5763, 126.9769),
          owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02"),
      Diary(
          title: "Lotte World Tower",
          content:
              "Visiting Lotte World Tower was an unforgettable experience.",
          image: "placeholder.jpg",
          date: DateTime(2023, 12, 10),
          location: NLatLng(37.5139, 127.1028),
          owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02"),
      Diary(
          title: "Bulguksa Temple",
          content: "Visiting Bulguksa Temple was an unforgettable experience.",
          image: "placeholder.jpg",
          date: DateTime(2023, 10, 29),
          location: NLatLng(35.7892, 129.3310),
          owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02"),
      Diary(
          title: "Suncheon Bay National Garden",
          content:
              "Visiting Suncheon Bay National Garden was an unforgettable experience.",
          image: "placeholder.jpg",
          date: DateTime(2023, 12, 9),
          location: NLatLng(34.8806, 127.4888),
          owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02"),
      Diary(
          title: "DMZ (Demilitarized Zone)",
          content:
              "Visiting DMZ (Demilitarized Zone) was an unforgettable experience.",
          image: "placeholder.jpg",
          date: DateTime(2023, 9, 4),
          location: NLatLng(37.9566, 126.6774),
          owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02"),
    ];
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    for (var d in diaries) {
      print("Adding diary: ${d.title}");
      Timestamp date = Timestamp.fromDate(d.date);
      firestore.collection('Diaries').add({
        'title': d.title,
        'content': d.content,
        'date': date,
        'location': GeoPoint(d.location.latitude, d.location.longitude),
        'image': d.image,
      });
    }
  }
}
