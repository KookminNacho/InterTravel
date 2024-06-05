import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class ImageDataSource {
  Future<Uint8List?> getImage(String url) async {
    Reference gsReference = FirebaseStorage.instance.refFromURL(url);

    Uint8List? image = await gsReference.getData();
    if (image == null) {
      print("ImageDataSource getImage: image is null");
      return null;
    } else {
      return image;
    }
  }

  Future<String> upLoadImage(Uint8List image, String title) async {
    Reference ref = FirebaseStorage.instance.ref().child("images/$title.jpg");
    await ref.putData(image);

    String imgURL = await ref.getDownloadURL();
    return imgURL;
  }
}
