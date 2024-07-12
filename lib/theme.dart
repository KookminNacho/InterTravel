import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData light() {
    return ThemeData(
      fontFamily: 'Pretendard',
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF4A90E2), // 밝은 파란색
      primaryColorLight: const Color(0xFF5DA9FF), // 더 밝은 파란색
      primaryColorDark: const Color(0xFF3A70B2), // 어두운 파란색
      hintColor: const Color(0xFFF5A623), // 따뜻한 주황색
      canvasColor: const Color(0xFFF9FAFB), // 매우 밝은 회색
      scaffoldBackgroundColor: const Color(0xFFFFFFFF), // 흰색
      cardColor: const Color(0xFFFFFFFF), // 흰색
      dividerColor: const Color(0xFFE0E0E0), // 밝은 회색
      focusColor: const Color(0xFF4A90E2), // 밝은 파란색
      hoverColor: const Color(0xFF4A90E2).withOpacity(0.1), // 반투명한 파란색
      highlightColor: const Color(0xFF4A90E2).withOpacity(0.2), // 반투명한 파란색
      splashColor: const Color(0xFF4A90E2).withOpacity(0.3), // 반투명한 파란색
      unselectedWidgetColor: const Color(0xFFBDBDBD), // 중간 톤의 회색
      disabledColor: const Color(0xFFE0E0E0), // 밝은 회색
      buttonTheme: ButtonThemeData(
        buttonColor: const Color(0xFF4A90E2), // 밝은 파란색
        disabledColor: const Color(0xFFBDBDBD), // 중간 톤의 회색
        highlightColor: const Color(0xFF3A70B2), // 어두운 파란색
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF333333), fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(color: Color(0xFF333333), fontSize: 14, fontWeight: FontWeight.w400),
        displayLarge: TextStyle(color: Color(0xFF333333), fontSize: 24, fontWeight: FontWeight.w500),
        displayMedium: TextStyle(color: Color(0xFF333333), fontSize: 22, fontWeight: FontWeight.w600),
        displaySmall: TextStyle(color: Color(0xFF333333), fontSize: 20, fontWeight: FontWeight.w500),
        headlineMedium: TextStyle(color: Color(0xFF333333), fontSize: 18, fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(color: Color(0xFF333333), fontSize: 16, fontWeight: FontWeight.w400),
        titleLarge: TextStyle(color: Color(0xFF333333), fontSize: 14, fontWeight: FontWeight.w400),
        titleMedium: TextStyle(color: Color(0xFF333333), fontSize: 20, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: Color(0xFF333333), fontSize: 18, fontWeight: FontWeight.w500),
        bodySmall: TextStyle(color: Color(0xFF757575), fontSize: 14, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: Color(0xFF757575), fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(color: Color(0xFF333333), fontSize: 14, fontWeight: FontWeight.w600),
      ),
      colorScheme: const ColorScheme(
        background: Color(0xFFFFFFFF), // 흰색
        brightness: Brightness.light,
        error: Color(0xFFE74C3C), // 밝은 빨간색
        onBackground: Color(0xFF333333), // 매우 어두운 회색
        onError: Color(0xFFFFFFFF), // 흰색
        onPrimary: Color(0xFFFFFFFF), // 흰색
        onSecondary: Color(0xFFFFFFFF), // 흰색
        onSurface: Color(0xFF333333), // 매우 어두운 회색
        primary: Color(0xFF4A90E2), // 밝은 파란색
        secondary: Color(0xFFF5A623), // 따뜻한 주황색
        surface: Color(0xFFF9FAFB), // 매우 밝은 회색
      ),
      bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xFFFFFFFF)),
    );
  }
}