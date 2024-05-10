
import 'package:flutter/cupertino.dart';

class UIViewModel extends ChangeNotifier {
  double _welcomeHeight = 200;
  double _welcomePosition = 400;

  double get welcomeHeight => _welcomeHeight;
  double get welcomePosition => _welcomePosition;

  bool _firstLoad = true;
  bool get firstLoad => _firstLoad;

  Future<void> setFirstLoad(bool)async {
    _firstLoad = bool;
    notifyListeners();
  }

  void bigWelcome() {
    _welcomeHeight = 400;
    notifyListeners();
  }

  void smallWelcome() {
    _welcomeHeight = 200;
    notifyListeners();
  }

  set welcomeHeight(double value) {
    _welcomeHeight = value;
    notifyListeners();
  }

  set welcomePosition(double value) {
    _welcomePosition = value;
    notifyListeners();
  }

}