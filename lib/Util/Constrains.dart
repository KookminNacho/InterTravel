import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color loginColor = Colors.black;

double loginHeight = 200;

double welcomeHeight = 500;

int animationDuration = 150;
List<double> photoAngleSpread =
    [0.0] + List.generate(99, (index) => Random().nextDouble() * 0.5 - 0.25);

List<List<double>> photoPositionSpread = List.generate(
    100,
    (index) => [
          Random().nextDouble() * 10 - 5,
          Random().nextDouble() * 10 - 5,
        ]);

String formatDate(DateTime date) {
  return DateFormat('yyyy년 MM월 dd일 hh:mm').format(date);
}
