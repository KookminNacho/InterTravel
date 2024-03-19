import 'package:flutter/cupertino.dart';
import 'package:intertravel/main.dart';

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
  GlobalPageRoute.mainPage: (context) => const MainPage(),
};

Widget currentPage = LoginPage();

void ChangeBottomSheet(Widget widget, BuildContext context) {

}