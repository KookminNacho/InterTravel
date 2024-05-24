import 'dart:math';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intertravel/View/AddNewDiaryPage.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:intertravel/ViewModel/ImageProvider.dart';
import 'package:provider/provider.dart';

import 'Model/Diary.dart';
import 'Util/Constrains.dart';
import 'View/DiaryPreview.dart';
import 'View/RandomStackPhoto.dart';
import 'ViewModel/UIViewMode.dart';
import 'ViewModel/UserData.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  MenuController menuController = MenuController();
  @override
  Widget build(BuildContext context) {
    return Container(
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
                              DiaryPreView(),
                              if (selectedDiary != null) Scaffold(
                                backgroundColor: Colors.white,
                                body: Column(
                                  children: [
                                    Flexible(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            BackButton(
                                              onPressed: () {
                                                DiaryProvider diary =
                                                Provider.of<DiaryProvider>(
                                                    context,
                                                    listen: false);

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
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                            SubmenuButton(
                                              controller: menuController,
                                              menuChildren: [
                                                MenuItemButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                        builder: (context)
                                                    =>
                                                        AddNewDiaryPage(
                                                          diary: selectedDiary,)
                                                    ));
                                                  },
                                                  child: Text("수정"),
                                                ),
                                                MenuItemButton(
                                                  child: Text("삭제"),
                                                  onPressed: (){
                                                    showDialog(context: context, builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text("삭제"),
                                                        content: const Text("삭제하시겠습니까?"),
                                                        actions: [
                                                          MaterialButton(
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Text("취소")),
                                                          MaterialButton(
                                                              onPressed: () {
                                                                Provider.of<DiaryProvider>(context, listen: false).deleteDiary(selectedDiary);
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Text("확인")),
                                                        ],
                                                      );

                                                    });
                                                  },
                                                ),
                                              ],
                                              child: const Icon(
                                                  Icons.more_vert),
                                            ),
                                          ],
                                        )),
                                    Flexible(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 3,
                                                blurRadius: 3,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    55, 0, 0, 0))),
                                        padding: const EdgeInsets.all(60.0),
                                        child: const Center(
                                            child: RandomStackPhoto()),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(top: 32.0),
                                      child: MaterialButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, "/diary");
                                          },
                                          child: const Text("읽기",
                                              style: TextStyle(
                                                fontSize: 24,
                                              )),
                                          color: Colors.white,
                                          elevation: 0),
                                    ),
                                  ],
                                ),
                              ) else Container(),
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
}
