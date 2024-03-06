import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';

import '../GlobalPageRoute.dart';
import '../Provider/UserData.dart';
import '../Provider/UserPermission.dart';
import '../Util/Constrains.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserPermission>(builder: (context, userPermission, child) {
      return (userPermission.locationPermission)
          ? Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AnimatedContainer(
                  color: overlayColor,
                  duration: Duration(milliseconds: 300),
                ),
                AnimatedContainer(
                  transform: Matrix4.translationValues(0, overlayHeight, 0),
                  duration: Duration(milliseconds: 300),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 186, 186, 186),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: MaterialButton(
                            onPressed: null,
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 1.2,
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
                              width: MediaQuery.of(context).size.width / 1.2,
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
                            Navigator.popAndPushNamed(
                                context, GlobalPageRoute.mainPage);
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
  }
}
