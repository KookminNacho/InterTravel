import 'package:flutter/material.dart';

class CustomLocationDialog extends StatelessWidget {
  const CustomLocationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('위치 설정'),
      content: const Text('여기에 위치 설정 UI가 들어갑니다.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            // 위치를 설정하는 로직 추가
            Navigator.of(context).pop();
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}