import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intertravel/Repository/AuthRepository.dart';
import 'package:provider/provider.dart';

import '../ViewModel/UserData.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double buttonHeight = MediaQuery.of(context).size.height / 15;
    return Consumer<UserData>(builder: (context, userData, child) {
      AuthRepository authRepository = AuthRepository();
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: MaterialButton(
                onPressed: () async {
                  UserCredential? user =
                      await authRepository.signInWithGoogle(userData);
                  if (user != null) {
                    userData.user = user.user;
                    // loadPage();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: buttonHeight,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    "구글로 시작하기",
                    style: TextStyle(
                      color: Color.fromARGB(255, 118, 118, 118),
                      fontSize: 16,
                    ),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: MaterialButton(
                onPressed: null,
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: buttonHeight,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 245, 0),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    "카카오로 시작하기 (개발 예정)",
                    style: TextStyle(
                      color: Color.fromARGB(255, 101, 48, 0),
                      fontSize: 16,
                    ),
                  ),
                )),
          ),
          // MaterialButton(
          //     onPressed: () {
          //       // setState(() {
          //       //   loadPage();
          //       // });
          //     },
          //     child: Container(
          //       alignment: Alignment.center,
          //       width: MediaQuery.of(context).size.width / 1.2,
          //       height: buttonHeight,
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(10)),
          //       child: const Text(
          //         "게스트로 시작하기",
          //         style: TextStyle(
          //           color: Color.fromARGB(255, 118, 118, 118),
          //           fontSize: 16,
          //         ),
          //       ),
          //     )),
        ],
      );
    });
  }
}
