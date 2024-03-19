import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intertravel/DataSource/AuthDataSource.dart';
import 'package:intertravel/Repository/AuthRepository.dart';
import 'package:provider/provider.dart';

import '../GlobalPageRoute.dart';
import '../Util/Constrains.dart';
import '../ViewModel/UserData.dart';
import '../ViewModel/UserPermission.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isOverlay = true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isOverlay,
      child: Consumer<UserData>(builder: (context, userData, child) {
        return Consumer<UserPermission>(
            builder: (context, userPermission, child) {
          AuthRepository authRepository = AuthRepository();
          return (userPermission.locationPermission)
              ? Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AnimatedContainer(
                      color: loginColor,
                      duration: Duration(milliseconds: animationDuration),
                    ),
                    AnimatedContainer(
                      transform: Matrix4.translationValues(0, loginHeight, 0),
                      duration: Duration(milliseconds: animationDuration),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 186, 186, 186),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: MaterialButton(
                                onPressed: () async {
                                  UserCredential? user =
                                      await authRepository.signInWithGoogle();
                                  if (user != null) {
                                    userData.user = user;
                                    loadPage();
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
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
                                onPressed: () {
                                  Provider.of<UserData>(context, listen: false)
                                      .updateLocation();
                                  Navigator.popAndPushNamed(
                                      context, GlobalPageRoute.routeLogin);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 245, 0),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Text(
                                    "카카오로 시작하기",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 101, 48, 0),
                                      fontSize: 16,
                                    ),
                                  ),
                                )),
                          ),
                          MaterialButton(
                              onPressed: () {
                                setState(() {
                                  loadPage();
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Text(
                                  "게스트로 시작하기",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 118, 118, 118),
                                    fontSize: 16,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: () {
                    userPermission.requestLocationPermission();
                  },
                  child: const Text("권한을 허용해주세요!"));
        });
      }),
    );
  }

  void loadPage() {
    loginHeight = MediaQuery.of(context).size.height / 2.5;
    loginColor = Colors.transparent;
    Future.delayed(Duration(milliseconds: animationDuration), () {
      setState(() {
        _isOverlay = false;
        welcomeHeight = 0;
      });
      Provider.of<UserData>(context, listen: false).mapLoad = true;
    });
  }

  void removeOverlay() {
    setState(() {
      _isOverlay = false;
    });
  }
}
