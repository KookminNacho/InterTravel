import 'package:flutter/material.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/UserData.dart';

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
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Text('이곳은 설정 다이얼로그입니다.'),
            const Text('현재는 로그아웃 기능을 추가할 예정입니다.'),
            MaterialButton(
                onPressed: () {
                  signOut();
                },
                child: const Text("로그아웃")),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('확인'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void signOut() {
    Provider.of<UserData>(context, listen: false)
        .signOut(Provider.of<DiaryProvider>(context, listen: false));
    Navigator.of(context).pop();
  }
}
