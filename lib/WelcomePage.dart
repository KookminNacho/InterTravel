import 'dart:math';
import 'dart:typed_data';

import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25.0),
      height: welcomeHeight + 50,
      child: Column(
        children: [
          Expanded(
            child: Selector<DiaryProvider, Diary?>(
              builder: (_, selectedDiary, __) {
                return Selector<UserData, User?>(
                  builder: (context, userData, child) {
                    return Consumer<ImageProviderModel>(
                        builder: (context, imageProvider, child) {
                      return Stack(
                        children: [
                          DiaryPreView(),
                          (selectedDiary != null)
                              ? Scaffold(
                                  body: Column(
                                    children: [
                                      Flexible(
                                          child: Row(
                                        children: [
                                          BackButton(
                                            onPressed: () {
                                              DiaryProvider diary =
                                                  Provider.of<DiaryProvider>(
                                                      context,
                                                      listen: false);

                                              diary.selectDiary(Diary(
                                                  date: DateTime.now(),
                                                  location: NLatLng(1, 1),
                                                  owner: userData!.uid,
                                                  title: "temp",
                                                  content: "temp",
                                                  imageURI: ["a", "b", "c"]));
                                              diary.selectDiary(null);
                                            },
                                          ),
                                          Text(
                                            selectedDiary.title,
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      )),
                                      Container(
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 32.0),
                                        child: MaterialButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, "/diary");
                                            },
                                            child: const Text("자세히")),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      );
                    });
                  },
                  selector: (_, userData) {
                    return userData.user;
                  },
                );
              },
              selector: (_, provider) {
                return provider.selectedDiary;
              },
            ),
          ),
        ],
      ),
    );
  }
}
