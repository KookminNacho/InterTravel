import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intertravel/Repository/ImageRepository.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';

import '../Model/Diary.dart';
import 'UserData.dart';

class ImageProviderModel with ChangeNotifier {
  final Map<String, List<Uint8List?>> _images = {};
  final ImageRepository _imageRepository = ImageRepository();
  bool _isLoaded = false;
  int imageRequestCount = 0;

  Map<String, List<Uint8List?>> get images => _images;

  bool get isLoaded => _isLoaded;

  Future<void> loadImage(DiaryProvider diary, int i) async {
    for (String imageURI in diary.diaries[i].imageURI) {
      if (_images.containsKey(imageURI)) {
        continue;
      }
      List<Uint8List?> image = await _imageRepository.loadImage(imageURI);
      _images[imageURI] = image;
      imageRequestCount++;
      print("imageRequestCount: $imageRequestCount");
      notifyListeners();
    }
    if(diary.diaries.length == i + 1) {
      isLoaded = true;
    }
  }

  set isLoaded(bool value) {
    _isLoaded = value;
    print("ImageProviderModel isLoaded: $value");
    notifyListeners();
  }

  Future<List<String>> upLoadImage(UserData userData, List<String> images, Diary diary) async {
    List<String> imageURI = await _imageRepository.upLoadImage(userData, images, diary);
    diary.imageURI = imageURI;
    notifyListeners();

    return imageURI;
  }
}
