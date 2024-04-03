import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../Model/Diary.dart';

class ImagedMarker extends StatefulWidget {
  final Diary diary;
  final Uint8List bytes;

  const ImagedMarker({super.key, required this.diary, required this.bytes});

  @override
  State<ImagedMarker> createState() => _ImagedMarkerState();
}

class _ImagedMarkerState extends State<ImagedMarker> {
  late Image image;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      image = await Image.memory(widget.bytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Uint8List: ${widget.bytes.length} ${widget.bytes.runtimeType}");
    return Column(
      children: [
        Container(
            height: 40,
            width: 48,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: image),
        Container(
          color: Colors.grey,
          height: 4,
          width: 2,
        )
      ],
    );
  }
}
