import "package:flutter/material.dart";

class AppSettingPage extends StatelessWidget {
  const AppSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('앱 설정'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () { },
              child: const Text('알림 설정'),

            )]))
    );
  }
}
