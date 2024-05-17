import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/cupertino.dart';

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
}

var namedRoutes = <String, WidgetBuilder>{
  GlobalPageRoute.routeLogin: (context) => LoginPage(),
  GlobalPageRoute.routeSignup: (context) => SignUpPage(),
  GlobalPageRoute.mainPage: (context) =>MainPage(),
  GlobalPageRoute.diary: (context) => DiaryPage(),
};

Widget currentPage = LoginPage();

