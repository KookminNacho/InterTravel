
import 'package:flutter/cupertino.dart';

class UIViewModel extends ChangeNotifier {
  double _welcomeHeight = 200;
  double _welcomePosition = 400;

  double get welcomeHeight => _welcomeHeight;
  double get welcomePosition => _welcomePosition;

  set welcomeHeight(double value) {
    _welcomeHeight = value;
    notifyListeners();
  }

  set welcomePosition(double value) {
    _welcomePosition = value;
    notifyListeners();
  }

}