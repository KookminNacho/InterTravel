import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:intertravel/ViewModel/ImageProvider.dart';
import 'package:provider/provider.dart';

import 'Model/Diary.dart';
import 'Util/Constrains.dart';
import 'View/DiaryPreview.dart';
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
      color: Colors.white,
      child: Selector<DiaryProvider, Diary?>(
        builder: (_, selectedDiary, __) {
          return Selector<UserData, User?>(
            builder: (context, userData, child) {
              return Consumer<ImageProviderModel>(
                  builder: (context, imageProvider, child) {
                return (selectedDiary != null)
                    ? Column(
                        children: [
                          Flexible(
                              child: Text(
                            selectedDiary.title,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w700),
                          )),
                          Flexible(
                              child: Text(formatDate(selectedDiary.date),
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey))),
                          Flexible(
                              flex: 6,
                              fit: FlexFit.tight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ImageSlideshow(
                                  width: MediaQuery.of(context).size.width,
                                  initialPage: 0,
                                  indicatorBottomPadding: 16,
                                  children: selectedDiary.imageURI
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 36.0),
                                            child: Image.memory(
                                              imageProvider.images[e]![1]!,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ))
                        ],
                      )
                    : DiaryPreView();
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
    );
  }
}
