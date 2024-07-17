import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intertravel/Repository/AuthRepository.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../ViewModel/UserData.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late NaverMapController _mapController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserData>(builder: (context, userData, child) {
      AuthRepository authRepository = AuthRepository();
      return Scaffold(
        body: Stack(
          children: [
            NaverMap(
              onMapReady: (controller) {
                _mapController = controller;
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade200.withAlpha(155),
                    Colors.purple.shade200.withAlpha(205)
                  ],
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(),
                      FadeTransition(
                        opacity: _animation,
                        child: Column(
                          children: [
                            Text(
                              "InterTravel",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w500,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: [Colors.blue, Colors.purple],
                                  ).createShader(const Rect.fromLTWH(
                                      0.0, 0.0, 200.0, 70.0)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "간편 로그인을 통해 여행을 시작하세요\n클릭 몇 번으로 시작!",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLoginButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );

                              UserCredential? userCred;
                              User? user;
                              bool loginSuccess = false;
                              try {
                                userCred = await authRepository
                                    .signInWithGoogle(userData);
                                if (userCred != null) {
                                  user = userCred.user;
                                  loginSuccess = true;
                                }
                              } catch (e) {
                                // 로그인 실패 처리
                                loginSuccess = false;
                              }

                              await Future.delayed(const Duration(seconds: 3));
                              Navigator.pop(context); // 로딩 다이얼로그 닫기
                              if (loginSuccess) {
                                userData.user = user;
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('로그인 실패'),
                                      content:
                                          const Text('로그인에 실패했습니다. 다시 시도해주세요.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('확인'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            color: Colors.white,
                            textColor: Colors.grey[800]!,
                            icon: FontAwesomeIcons.google,
                            text: "구글로 시작하기",
                          ),
                          const SizedBox(height: 16),
                          _buildLoginButton(
                            onPressed: null,
                            color: const Color(0xFFFEE500),
                            textColor: const Color(0xFF3C1E1E),
                            text: "카카오로 시작하기 (개발 예정)",
                            icon: FontAwesomeIcons.apple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLoginButton({
    required VoidCallback? onPressed,
    required Color color,
    required Color textColor,
    required IconData icon,
    required String text,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Text(text,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void RandomCameraMove() {
    final NCameraPosition _kInitialPosition = const NCameraPosition(
      target: NLatLng(37.3595704, 127.105399),
      zoom: 7.0,
    );
    NCameraUpdate cameraUpdate = NCameraUpdate.scrollAndZoomTo(
        target: NLatLng(37.3595704, 127.105399), zoom: 7.0);
    cameraUpdate.setAnimation(animation: NCameraAnimation.linear);
    _mapController.updateCamera(cameraUpdate);
  }
}
