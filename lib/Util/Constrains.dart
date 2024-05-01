import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color loginColor = Colors.black;

double loginHeight = 200;

double welcomeHeight = 400;

int animationDuration = 150;


String formatDate(DateTime date) {
  return DateFormat('yyyy년 MM월 dd일 hh:mm').format(date);
}