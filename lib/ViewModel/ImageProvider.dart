import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intertravel/Repository/ImageRepository.dart';
import 'dart:io';

import '../Model/Diary.dart';

class ImageProviderModel with ChangeNotifier {
  Map<String, List<Uint8List>> _images = {};
  ImageRepository _imageRepository = ImageRepository();
  bool _isLoaded = false;
  int imageRequestCount = 0;

  Map<String, List<Uint8List>> get images => _images;

  bool get isLoaded => _isLoaded;

  /* 이미지를 불러오는 메소드, 여러개를 한번에 불러오는데 사용자 경험 개선을 위해 하나씩 불러오는걸로 변경 */
  // Future<void> loadImages(List<Diary> diaries) async {
  //   _images = await _imageRepository.loadImages(diaries);
  //   _isLoaded = true;
  //   imageRequestCount += diaries.length;
  //   notifyListeners();
  // }

  Future<void> loadImage(Diary diary) async {
    for (String imageURI in diary.imageURI) {
      if (_images.containsKey(imageURI)) {
        continue;
      }
      List<Uint8List> image = await _imageRepository.loadImage(imageURI);
      _images[imageURI] = image;
      imageRequestCount++;
      print("imageRequestCount: $imageRequestCount");
      notifyListeners();
    }
  }

  Future<List<String>> upLoadImage(List<File> images, Diary diary) async {
    List<String> imageURI = await _imageRepository.upLoadImage(images, diary);
    diary.imageURI = imageURI;
    notifyListeners();

    return imageURI;
  }
}
