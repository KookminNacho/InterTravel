import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/cupertino.dart';

import 'View/LoginPage.dart';
import 'View/MainPage.dart';
import 'View/SignUpPage.dart';

class GlobalPageRoute {
  static const routeHome = '/';
  static const routeLogin = '/login';
  static const routeSignup = '/signup';
  static const mainPage = '/main';
}

var namedRoutes = <String, WidgetBuilder>{
  GlobalPageRoute.routeLogin: (context) => LoginPage(),
  GlobalPageRoute.routeSignup: (context) => SignUpPage(),
  GlobalPageRoute.mainPage: (context) =>
      DefaultBottomBarController(child: const MainPage()),
};

Widget currentPage = LoginPage();

