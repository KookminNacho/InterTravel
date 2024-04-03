import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intertravel/DataSource/ImageDataSource.dart';
import 'package:image/image.dart' as IMG;


import '../Model/Diary.dart';

class ImageRepository {
  Future<Map<String, Uint8List>> loadImages(List<Diary> diaries) async {
    ImageDataSource imageDataSource = ImageDataSource();
    Map<String, Uint8List> _images = {};

    for(Diary diary in diaries) {
      Uint8List image = await imageDataSource.getImage(diary.imageURI);
      IMG.Image img = IMG.decodeImage(image)!;
      img = IMG.copyResize(img, width: 200, height: 200);
      image = Uint8List.fromList(IMG.encodePng(img));

      _images[diary.imageURI] = image;
    }

    return _images;
  }
}
