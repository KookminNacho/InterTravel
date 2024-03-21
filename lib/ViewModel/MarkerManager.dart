
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MarkerManager {
  static Set<NMarker> overlays = {};
  static Map<String, double> size = {};

  static void extendMarker(NMarker marker) {
    for (int i = 0; i < overlays.length; i++) {
      if (overlays.elementAt(i).info.id == marker.info.id) {
        size[marker.info.id] = 200;
        print("Marker extended: ${marker.info.id}");
      }
      else{
        size[marker.info.id] = 50;
      }
    }
  }




}