import 'dart:typed_data';

import 'package:intertravel/DataSource/ImageDataSource.dart';
import 'package:image/image.dart' as IMG;
import 'package:intertravel/ViewModel/UserData.dart';
import 'dart:io';

import '../Model/Diary.dart';

class ImageRepository {
  // Future<Map<String, List<Uint8List>>> loadImages(List<Diary> diaries) async {
  //   ImageDataSource imageDataSource = ImageDataSource();
  //   Map<String, List<Uint8List>> _images = {};
  //
  //   for (Diary diary in diaries) {
  //     for (String imageURI in diary.imageURI) {
  //       Uint8List image = await imageDataSource.getImage(imageURI);
  //       IMG.Image img = IMG.decodeImage(image)!;
  //       IMG.Image bigimg = IMG.copyResize(img, width: -1, height: 600);
  //       img = IMG.copyResize(img, width: -1, height: 150);
  //       _images[imageURI] = [IMG.encodeJpg(img), IMG.encodeJpg(bigimg)];
  //     }
  //
  //     return _images;
  //   }

  Future<List<Uint8List?>> loadImage(String imageURI) async {
    ImageDataSource imageDataSource = ImageDataSource();
    Uint8List? image = await imageDataSource.getImage(imageURI);
    if (image == null) {
      return [null, null];
    }
    IMG.Image img = IMG.decodeImage(image)!;
    IMG.Image bigimg;
    if (img.height < img.width) {
      bigimg = IMG.copyResize(img, width: img.height, height: -1);
      img = IMG.copyResize(img, width: 150, height: -1);
    } else {
      bigimg = IMG.copyResize(img, width: -1, height: img.height);

      img = IMG.copyResize(img, width: -1, height: 150);
    }
    return [IMG.encodeJpg(img), IMG.encodeJpg(bigimg)];
  }

  Future<List<String>> upLoadImage(
      UserData userData, List<String> images, Diary diary) async {
    ImageDataSource imageDataSource = ImageDataSource();
    List<String> imageURI = [];
    int i = 0;
    for (String imagePath in images) {
      if (imagePath.contains(
          "https://firebasestorage.googleapis.com/v0/b/intertravel-fab82.appspot")) {
        imageURI.add(imagePath);
        print("Image Already exists: $imagePath");
        i++;
      } else {
        Uint8List byteData = await File(imagePath).readAsBytes();
        String imgURL = await imageDataSource.upLoadImage(byteData,
            "${userData.uid}/${diary.title + DateTime.now().toString()}N${i++}");
        imageURI.add(imgURL);
      }
    }
    return imageURI;
  }
}
