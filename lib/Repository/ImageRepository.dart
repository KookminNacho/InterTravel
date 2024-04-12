import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intertravel/DataSource/ImageDataSource.dart';
import 'package:image/image.dart' as IMG;

import '../Model/Diary.dart';

class ImageRepository {
  Future<Map<String, List<Uint8List>>> loadImages(List<Diary> diaries) async {
    ImageDataSource imageDataSource = ImageDataSource();
    Map<String, List<Uint8List>> _images = {};

    for (Diary diary in diaries) {
      Uint8List image = await imageDataSource.getImage(diary.imageURI);
      IMG.Image img = IMG.decodeImage(image)!;
      IMG.Image bigimg = IMG.copyResize(img, width: -1, height: 600);
      img = IMG.copyResize(img, width: -1, height: 150);
      _images[diary.imageURI] = [IMG.encodeJpg(img), IMG.encodeJpg(bigimg)];
    }

    return _images;
  }

  Future<List<Uint8List>> loadImage(String imageURI) async {
    ImageDataSource imageDataSource = ImageDataSource();
    Uint8List image = await imageDataSource.getImage(imageURI);
    IMG.Image img = IMG.decodeImage(image)!;
    IMG.Image bigimg = IMG.copyResize(img, width: -1, height: 600);
    img = IMG.copyResize(img, width: -1, height: 150);
    return [IMG.encodeJpg(img), IMG.encodeJpg(bigimg)];
  }
}
