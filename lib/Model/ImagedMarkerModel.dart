import "package:flutter_naver_map/flutter_naver_map.dart";

class MarkerModel {
  final String title;
  final NLatLng position;
  final NOverlayImage image;

  MarkerModel({
    required this.title,
    required this.position,
    required this.image,
  });
}
