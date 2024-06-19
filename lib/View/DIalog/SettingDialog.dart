import 'package:flutter/material.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/UserData.dart';
import '../ProfileSettingPage.dart';

class SettingDialog extends StatefulWidget {
  const SettingDialog({super.key});

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('설정'),
      content: SizedBox(
        height: 200,
        child: Column(
          children: <Widget>[
            const Text('추후 기능 추가 예정입니다.'),
            MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileSettingPage()));
                },
                child: const Text(
                  "계정 설정",
                )),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('닫기'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

}
