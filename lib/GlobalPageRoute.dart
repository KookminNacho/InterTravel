import 'package:flutter/cupertino.dart';
import 'package:intertravel/Map/MainPage.dart';
import 'package:intertravel/main.dart';

import 'Profile/LoginPage.dart';
import 'Profile/SignUpPage.dart';

class GlobalPageRoute {
  static const routeHome = '/';
  static const routeLogin = '/login';
  static const routeSignup = '/signup';
  static const mainPage = '/main';
}

var namedRoutes = <String, WidgetBuilder>{
  GlobalPageRoute.routeLogin: (context) => LoginPage(),
  GlobalPageRoute.routeSignup: (context) => SignUpPage(),
  GlobalPageRoute.mainPage: (context) => const MainPage(),
};
