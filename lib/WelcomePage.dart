import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';

import '../Model/Diary.dart';
import '../Util/Constrains.dart';
import '../View/AddNewDiaryPage.dart';
import '../View/RandomStackPhoto.dart';
import '../ViewModel/DiaryProvider.dart';
import '../ViewModel/ImageProvider.dart';
import '../ViewModel/UIViewMode.dart';
import '../ViewModel/UserData.dart';
import 'View/DiaryPreview.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: Colors.white
      ),
      padding: const EdgeInsets.only(top: 25.0),
      height: welcomeHeight + 50,
      child: Column(
        children: [
          Expanded(
            child: Consumer<DiaryProvider>(
              builder: (context, diaryProvider, child) {
                Diary? selectedDiary = diaryProvider.selectedDiary;
                return Selector<UserData, User?>(
                  builder: (context, userData, child) {
                    return Consumer<ImageProviderModel>(
                        builder: (context, imageProvider, child) {
                          return Stack(
                            children: [
                              const DiaryPreView(),
                              if (selectedDiary != null) SelectedDiaryView(userData, selectedDiary) else Container(),
                            ],
                          );
                        });
                  },
                  selector: (_, userData) {
                    return userData.user;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget SelectedDiaryView(User? userData, Diary selectedDiary) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(
                    onPressed: () {
                      DiaryProvider diary = Provider.of<DiaryProvider>(context, listen: false);

                      diary.selectDiary(Diary(
                          uid: "local",
                          date: DateTime.now(),
                          location: NLatLng(1, 1),
                          owner: userData!.uid,
                          title: "temp",
                          content: "temp",
                          imageURI: ["a", "b", "c"]));
                      diary.selectDiary(null);
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: AutoSizeText(
                      selectedDiary.title,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (BuildContext context) { return [
                      PopupMenuItem(child: Text("수정"), onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewDiaryPage(diary: selectedDiary)));
                      },),
                      PopupMenuItem(child: Text("삭제"), onTap: (){
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("일기 삭제"),
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("정말로 삭제하시겠습니까?", style: TextStyle(fontSize: 16)),
                                  RichText(text: TextSpan(
                                    style: TextStyle(color: Colors.black, fontSize: 14),
                                    children: [
                                      TextSpan(text: "일기 제목: "),
                                      TextSpan(text: selectedDiary.title, style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                            actions: [
                              MaterialButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: Text("취소")),
                              MaterialButton(onPressed: (){
                                Provider.of<DiaryProvider>(context, listen: false).deleteDiary(selectedDiary);
                                Navigator.pop(context);
                              }, child: Text("확인")),
                            ],

                          );
                        });
                      },),
                    ];},
                    child: const Icon(Icons.more_vert),
                  ),
                ],
              )),
          Divider(),
          RandomStackPhoto(),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/diary");
                },
                color: Colors.white,
                elevation: 0,
                child: const Text("읽기", style: TextStyle(fontSize: 24))),
          ),
        ],
      ),
    );
  }
}
