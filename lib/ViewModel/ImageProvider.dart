import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intertravel/Repository/ImageRepository.dart';

import '../Model/Diary.dart';

class ImageProviderModel with ChangeNotifier {
  Map<String, Uint8List> _images = {};
  ImageRepository _imageRepository = ImageRepository();

  Map<String, Uint8List> get images => _images;

  Future<void> loadImages(List<Diary> diaries) async {
    _images = await _imageRepository.loadImages(diaries);
    notifyListeners();
  }


}
