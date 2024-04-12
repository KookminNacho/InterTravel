import 'package:flutter/material.dart';
import 'package:intertravel/Util/Constrains.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:provider/provider.dart';

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
        return AnimatedContainer(
          transform: Matrix4.translationValues(0, welcomeHeight, 0),
          duration: Duration(milliseconds: animationDuration),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          height: 400,
          width: MediaQuery.of(context).size.width,
          child: (diaryProvider.isLoaded)
              ? Column(
                  children: [
                    Text("반가워요, ${userData.user?.user?.displayName}"),
                    Text("당신의 UID는 \"${userData.user?.user?.uid}\"입니다."),
                    Text("현재 당신은 ${userData.user?.user?.email}로 로그인 중입니다."),
                    Text("일기의 개수는 ${diaryProvider.diaries.length}개 입니다."),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        );
      });
    });
  }
}
