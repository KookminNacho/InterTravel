import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:intertravel/Util/Constrains.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:intertravel/ViewModel/ImageProvider.dart';
import 'package:provider/provider.dart';

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
    return Consumer<DiaryProvider>(builder: (context, diaryProvider, child) {
      return Consumer<UserData>(builder: (context, userData, child) {
        return Consumer<ImageProviderModel>(
            builder: (context, imageProvider, child) {
          return Consumer<UIViewModel>(
              builder: (context, UIViewModel uiViewModel, child) {
            return AnimatedContainer(
                transform: Matrix4.translationValues(
                    0, uiViewModel.welcomePosition, 0),
                duration: Duration(milliseconds: animationDuration),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                height: uiViewModel.welcomeHeight,
                width: MediaQuery.of(context).size.width,
                child: (diaryProvider.isLoaded)
                    ? ((diaryProvider.selectedDiary == null))
                        ? Column(children: [
                            Text("반가워요, ${userData.user?.user?.displayName}"),
                            Text(
                                "일기의 개수는 ${diaryProvider.diaries.length}개 입니다."),
                            Container(
                                height: 100,
                                child: userData.photo),
                          ])
                        : Column(
                            children: [
                              Text(
                                  "현재 선택한 일기는 ${diaryProvider.selectedDiary?.title}입니다."),
                              Text(diaryProvider.selectedDiary!.content),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ImageSlideshow(
                                  width: MediaQuery.of(context).size.width,
                                  initialPage: 0,
                                  indicatorColor: Colors.blue,
                                  indicatorBackgroundColor: Colors.grey,
                                  indicatorBottomPadding: 16,
                                  children:
                                      diaryProvider.selectedDiary!.imageURI
                                          .map((e) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 36.0),
                                                child: Image.memory(
                                                  imageProvider.images[e]![1],
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ))
                                          .toList(),
                                ),
                              ))
                            ],
                          )
                    : const Center(child: CircularProgressIndicator()));
          });
        });
      });
    });
  }
}
