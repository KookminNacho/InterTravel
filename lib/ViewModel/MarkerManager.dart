import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MarkerManager extends ChangeNotifier {
  final Set<NMarker> _markers = {};

  Set<NMarker> get markers => _markers;



  void addMarker(NMarker marker) {
    _markers.add(marker);
    notifyListeners();
  }

  void removeMarker(NMarker marker) {
    _markers.remove(marker);
    notifyListeners();
  }
}
