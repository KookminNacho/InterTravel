import 'package:flutter/cupertino.dart';
import 'package:intertravel/View/DIalog/ListDialog.dart';

import 'View/DiaryPage.dart';
import 'View/LoginPage.dart';
import 'View/MainPage.dart';
import 'View/SignUpPage.dart';

class GlobalPageRoute {
  static const routeHome = '/';
  static const routeLogin = '/login';
  static const routeSignup = '/signup';
  static const mainPage = '/main';
  static const diary = '/diary';
  static const list = '/list';
}

var namedRoutes = <String, WidgetBuilder>{
  GlobalPageRoute.routeLogin: (context) => const LoginPage(),
  GlobalPageRoute.routeSignup: (context) => const SignUpPage(),
  GlobalPageRoute.mainPage: (context) => const MainPage(),
  GlobalPageRoute.diary: (context) => const DiaryPage(),
  GlobalPageRoute.list: (context) => const ListPage(),
};

// ignore: prefer_const_constructors
Widget currentPage = const LoginPage();
