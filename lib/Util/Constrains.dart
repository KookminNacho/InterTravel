import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color loginColor = Colors.black;

double loginHeight = 200;

double welcomeHeight = 500;

int animationDuration = 150;
List<double> photoAngleSpread =
    [0.0] + List.generate(99, (index) => Random().nextDouble() * 0.25 - 0.125);

List<List<double>> photoPositionSpread = List.generate(
    100,
    (index) => [
          Random().nextDouble() * 5 - 3,
          Random().nextDouble() * 5 - 3,
        ]);

const List<Color> colors = [
  Color(0xFFB0BEC5), // Blue Grey
  Color(0xFF78909C), // Dark Blue Grey
  Color(0xFF90A4AE), // Light Blue Grey
  Color(0xFFECEFF1), // Light Grey
  Color(0xFFCFD8DC), // Light Blue Grey 2
  Color(0xFFB3E5FC), // Light Blue
  Color(0xFFB2EBF2), // Light Cyan
  Color(0xFFC8E6C9), // Light Green
  Color(0xFFFFF9C4), // Light Yellow
  Color(0xFFFFCCBC), // Light Orange
];


String formatDate(DateTime date) {
  return DateFormat('yyyy년 MM월 dd일 hh:mm').format(date);
}

String timeDifference(DateTime date) {
  Duration difference = DateTime.now().difference(date);
  if (difference.inDays > 0) {
    return '${difference.inDays}일 전';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}시간 전';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}분 전';
  } else {
    return '방금 전';
  }
}
