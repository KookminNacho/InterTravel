import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData dark([ThemeData? template]) {
    var themeData = template ?? ThemeData.dark();
    var newThemeData = themeData.copyWith(
      canvasColor: Color.fromRGBO(25, 39, 62, 1),
      indicatorColor: Colors.deepOrange,
      textTheme: themeData.textTheme.apply(
        fontFamily: 'Pretendard',
      ),
      bottomAppBarTheme:
          BottomAppBarTheme(color: Color.fromRGBO(39, 59, 89, 1)),
      colorScheme: const ColorScheme(
          background: Color.fromRGBO(31, 50, 69, 1),
          brightness: Brightness.dark,
          error: Color.fromRGBO(255, 0, 0, 1),
          onBackground: Color.fromRGBO(255, 255, 255, 1),
          onError: Color.fromRGBO(255, 255, 255, 1),
          onPrimary: Color.fromRGBO(255, 255, 255, 1),
          onSecondary: Color.fromRGBO(255, 255, 255, 1),
          onSurface: Color.fromRGBO(255, 255, 255, 1),
          primary: Color.fromRGBO(39, 59, 89, 1),
          secondary: Color.fromRGBO(39, 59, 89, 1),
          surface: Color.fromRGBO(31, 50, 69, 1)),
    );

    return newThemeData;
  }
}
