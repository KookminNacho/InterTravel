import 'package:flutter/material.dart';

class ImageProviderModel with ChangeNotifier {
  Map<String, Image> _images = {};

  // 이미지를 불러오는 메소드
  Future<void> loadImage(String url) async {

    _images[url] = Image.network(url); // 간단한 예시입니다.
    notifyListeners(); // 이미지 로딩 상태 변경을 알립니다.
  }

  // 특정 URL의 이미지 가져오기
  Image? getImage(String url) {
    return _images[url];
  }
}
