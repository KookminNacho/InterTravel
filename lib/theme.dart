import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF1E88E5), // 밝은 파란색
      primaryColorLight: const Color(0xFF6AB7FF), // 밝은 파란색
      primaryColorDark: const Color(0xFF005CB2), // 어두운 파란색
      hintColor: const Color(0xFFFFC107), // 황금색
      canvasColor: const Color(0xFF2C3E50), // 짙은 회색
      scaffoldBackgroundColor: const Color(0xFF1A252F), // 어두운 회색
      cardColor: const Color(0xFF34495E), // 회색
      dividerColor: const Color(0xFF7F8C8D), // 밝은 회색
      focusColor: const Color(0xFF2980B9), // 파란색
      hoverColor: const Color(0xFF2980B9), // 파란색
      highlightColor: const Color(0xFF2980B9), // 파란색
      splashColor: const Color(0xFF2980B9), // 짙은 회색
      unselectedWidgetColor: const Color(0xFF7F8C8D), // 밝은 회색
      disabledColor: const Color(0xFF95A5A6), // 밝은 회색
      buttonTheme: ButtonThemeData(
        buttonColor: const Color(0xFF1E88E5), // 파란색
        disabledColor: const Color(0xFF95A5A6), // 밝은 회색
        highlightColor: const Color(0xFF2980B9), // 파란색
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16, fontWeight: FontWeight.w400), // 흰색
        bodyMedium: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.w400), // 흰색
        displayLarge: TextStyle(color: Color(0xFFFFFFFF), fontSize: 24, fontWeight: FontWeight.w700), // 흰색
        displayMedium: TextStyle(color: Color(0xFFFFFFFF), fontSize: 22, fontWeight: FontWeight.w600), // 흰색
        displaySmall: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20, fontWeight: FontWeight.w500), // 흰색
        headlineMedium: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18, fontWeight: FontWeight.w400), // 흰색
        headlineSmall: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16, fontWeight: FontWeight.w400), // 흰색
        titleLarge: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.w400), // 흰색
        titleMedium: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20, fontWeight: FontWeight.w600), // 흰색
        titleSmall: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18, fontWeight: FontWeight.w500), // 흰색
        bodySmall: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.w500), // 흰색
        labelSmall: TextStyle(color: Color(0xFFFFFFFF), fontSize: 12, fontWeight: FontWeight.w400), // 흰색
        labelLarge: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.w600), // 흰색
      ),
      colorScheme: const ColorScheme(
        background: Color(0xFF1A252F), // 어두운 회색
        brightness: Brightness.dark,
        error: Color(0xFFE74C3C), // 밝은 빨간색
        onBackground: Color(0xFFFFFFFF), // 흰색
        onError: Color(0xFFFFFFFF), // 흰색
        onPrimary: Color(0xFFFFFFFF), // 흰색
        onSecondary: Color(0xFFFFFFFF), // 흰색
        onSurface: Color(0xFFFFFFFF), // 흰색
        primary: Color(0xFF1E88E5), // 밝은 파란색
        secondary: Color(0xFFFFC107), // 황금색
        surface: Color(0xFF2C3E50), // 짙은 회색
      ), bottomAppBarTheme: BottomAppBarTheme(color: const Color(0xFF1A252F)),
    );
  }
}
