import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../Model/Diary.dart';

class DiarySource {
  Future<List<Diary>> getDiaries(String userID) async {
    List<Diary> diaries = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> response = await firestore
        .collection('Diaries')
        .where('owner', isEqualTo: userID)
        .get();

    var futures = response.docs.map((doc) async {
      List<String> url = [];
      for (var i in doc.data()['image']) {
        String imageURI = i;
        final ref = FirebaseStorage.instance.refFromURL(imageURI);
        try {
          String? urlStr = await ref.getDownloadURL();
          url.add(urlStr);
        } catch (e) {
          print(e);
        }
      }
      GeoPoint location = doc.data()['location'];
      NLatLng nLatLng = NLatLng(location.latitude, location.longitude);
      Timestamp tdate = doc.data()['date'];
      DateTime date = tdate.toDate();
      List<String> temp = [];
      for (final a in doc.data()['image']) {
        temp.add(a.toString());
      }

      return Diary(
        uid: doc.id,
        title: doc.data()['title'],
        content: doc.data()['content'],
        date: date,
        location: nLatLng,
        imageURI: url,
        owner: doc.data()['owner'],
        userID: doc.data()['userID'],
        address: doc.data()['address'],
      );
    }).toList();
    diaries = await Future.wait(futures);
    return diaries;
  }

  Future<bool> addDiary(Diary diary, String user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Timestamp date = Timestamp.fromDate(diary.date);
    try {
      await firestore.collection('Diaries').add({
        'title': diary.title,
        'content': diary.content,
        'date': date,
        'location': GeoPoint(diary.location.latitude, diary.location.longitude),
        'image': diary.imageURI,
        'owner': user,
        'address': diary.address,
      });
      print("Diary added ${diary.title}, ${diary.content}, ${diary.date}, ${diary.location}, ${diary.imageURI}, ${diary.address} $user");
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> updateDiary(Diary diary) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Timestamp date = Timestamp.fromDate(diary.date);
    try {
      firestore.collection('Diaries').doc(diary.uid).update({
        'title': diary.title,
        'content': diary.content,
        'date': date,
        'location': GeoPoint(diary.location.latitude, diary.location.longitude),
        'image': diary.imageURI,
        'owner': diary.owner,
        'address': diary.address,
      });
    } catch (e) {
      print(e);
      return false;
    }
    return true;

  }

  Future<bool> deleteDiary(Diary selectedDiary) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      firestore.collection('Diaries').doc(selectedDiary.uid).delete();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

// void addDiary() async {
//   print("Adding diaries");
//
//   List diaries = [
//     Diary(
//         title: "Gyeongbokgung Palace",
//         content:
//             "Visiting Gyeongbokgung Palace was an unforgettable experience.",
//         image: [
//           "gs://intertravel-fab82.appspot.com/KakaoTalk_Photo_2024-02-07-21-49-39 001.jpeg"
//         ],
//         date: DateTime(2024, 1),
//         location: NLatLng(37.5781, 126.9768),
//         owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02",
//         userID: "kim990321@gmail.com"),
//     Diary(
//         title: "N Seoul Tower",
//         content: "Visiting N Seoul Tower was an unforgettable experience.",
//         image: [
//           "gs://intertravel-fab82.appspot.com/KakaoTalk_Photo_2024-02-07-21-49-40 002.jpeg"
//         ],
//         date: DateTime(2023, 11, 11),
//         location: NLatLng(37.5512, 126.9882),
//         owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02",
//         userID: "kim990321@gmail.com"),
//     Diary(
//         title: "Bukchon Hanok Village",
//         content:
//             "Visiting Bukchon Hanok Village was an unforgettable experience.",
//         image: [
//           "gs://intertravel-fab82.appspot.com/KakaoTalk_Photo_2024-02-07-21-49-40 003.jpeg"
//         ],
//         date: DateTime(2023, 4, 9),
//         location: NLatLng(37.5824, 126.9830),
//         owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02",
//         userID: "kim990321@gmail.com"),
//     Diary(
//         title: "Jeonju Hanok Village",
//         content:
//             "Visiting Jeonju Hanok Village was an unforgettable experience.",
//         image: [
//           "gs://intertravel-fab82.appspot.com/KakaoTalk_Photo_2024-02-07-21-49-40 003.jpeg"
//         ],
//         date: DateTime(2023, 5, 2),
//         location: NLatLng(35.8151, 127.1539),
//         owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02",
//         userID: "kim990321@gmail.com"),
//     Diary(
//         title: "Haeundae Beach",
//         content: "Visiting Haeundae Beach was an unforgettable experience.",
//         image: [
//           "gs://intertravel-fab82.appspot.com/KakaoTalk_Photo_2024-02-16-17-50-07.jpeg"
//         ],
//         date: DateTime(2024, 2, 17),
//         location: NLatLng(35.1587, 129.1604),
//         owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02",
//         userID: "kim990321@gmail.com"),
//     Diary(
//         title: "Gwanghwamun Square",
//         content:
//             "Visiting Gwanghwamun Square was an unforgettable experience.",
//         image: [
//           "gs://intertravel-fab82.appspot.com/KakaoTalk_Photo_2024-02-16-17-50-07.jpeg"
//         ],
//         date: DateTime(2023, 5, 18),
//         location: NLatLng(37.5763, 126.9769),
//         owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02",
//         userID: "kim990321@gmail.com"),
//     Diary(
//         title: "Lotte World Tower",
//         content:
//             "Visiting Lotte World Tower was an unforgettable experience.",
//         image: [
//           "gs://intertravel-fab82.appspot.com/KakaoTalk_Snapshot_20240206_153547.png"
//         ],
//         date: DateTime(2023, 12, 10),
//         location: NLatLng(37.5139, 127.1028),
//         owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02",
//         userID: "kim990321@gmail.com"),
//     Diary(
//         title: "Bulguksa Temple",
//         content: "Visiting Bulguksa Temple was an unforgettable experience.",
//         image: [
//           "gs://intertravel-fab82.appspot.com/KakaoTalk_Snapshot_20240206_153547.png"
//         ],
//         date: DateTime(2023, 10, 29),
//         location: NLatLng(35.7892, 129.3310),
//         owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02",
//         userID: "kim990321@gmail.com"),
//     Diary(
//         title: "Suncheon Bay National Garden",
//         content:
//             "Visiting Suncheon Bay National Garden was an unforgettable experience.",
//         image: [
//           "gs://intertravel-fab82.appspot.com/KakaoTalk_Snapshot_20240206_153547.png"
//         ],
//         date: DateTime(2023, 12, 9),
//         location: NLatLng(34.8806, 127.4888),
//         owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02",
//         userID: "kim990321@gmail.com"),
//     Diary(
//         title: "DMZ (Demilitarized Zone)",
//         content:
//             "Visiting DMZ (Demilitarized Zone) was an unforgettable experience.",
//         image: [
//           "gs://intertravel-fab82.appspot.com/KakaoTalk_Snapshot_20240206_153547.png"
//         ],
//         date: DateTime(2023, 9, 4),
//         location: NLatLng(37.9566, 126.6774),
//         owner: "QtVM9ksIScXQ29RPlWCgXUlSfP02",
//         userID: "kim990321@gmail.com"),
//   ];
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   for (var d in diaries) {
//     print("Adding diary: ${d.title}");
//     Timestamp date = Timestamp.fromDate(d.date);
//     firestore.collection('Diaries').add({
//       'title': d.title,
//       'content': d.content,
//       'date': date,
//       'location': GeoPoint(d.location.latitude, d.location.longitude),
//       'image': d.image,
//       'owner': d.owner,
//       'userID': d.userID
//     });
//   }
// }
}
