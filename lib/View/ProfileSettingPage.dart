import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/DiaryProvider.dart';
import '../ViewModel/UserData.dart';

class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({super.key});

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('계정 설정'),
        ),
        body: Column(
          children: <Widget>[
            ListTile(
              onTap: () {
                //기능 추가예정 스낵바 표시
                unReleasedFunction();
              },
              title: const Text(
                '프로필 사진 변경',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            const Divider(),
            ListTile(
                onTap: () {
                  unReleasedFunction();
                },
                title: const Text(
                  '닉네임 변경',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                )),
            const Divider(),
            ListTile(
              onTap: () {
                signOutDialog();
              },
              title: const Text(
                '로그아웃',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                deleteAccountDialog();
              },
              title: const Text(
                '회원 탈퇴',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),
          ],
        ));
  }

  void unReleasedFunction() {
    ScaffoldMessenger.of(context).clearSnackBars();
    //기능 추가예정 스낵바 표시
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        content: Text('추후 기능 추가 예정입니다!'),
      ),
    );
  }

  void signOutDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('로그아웃'),
            content: const Text('로그아웃 하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  signOut();
                },
                child: const Text('확인'),
              ),
            ],
          );
        });
  }

  void signOut() {
    Provider.of<UserData>(context, listen: false)
        .signOut(Provider.of<DiaryProvider>(context, listen: false));
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void deleteAccountDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('회원 탈퇴'),
            content: const Text('정말로 탈퇴하시겠습니까? '),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  deleteAccount();
                },
                child: const Text('확인'),
              ),
            ],
          );
        });
  }

  // 회원 탈퇴
  void deleteAccount() {
    Provider.of<DiaryProvider>(context, listen: false).deleteAllDiaries();
    Provider.of<UserData>(context, listen: false)
        .deleteAccount(Provider.of<DiaryProvider>(context, listen: false));
    Navigator.of(context).pop();
  }
}
