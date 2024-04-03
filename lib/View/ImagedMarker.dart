import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../Model/Diary.dart';

class ImagedMarker extends StatefulWidget {
  const ImagedMarker({super.key});

  @override
  State<ImagedMarker> createState() => _ImagedMarkerState();
}

class _ImagedMarkerState extends State<ImagedMarker> {
  late Image image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 34),
      child: Column(
        children: [
          Container(
            height: 66,
            width: 66,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(color: Colors.red, width: 3),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          // Container(
          //   color: Colors.grey,
          //   height: 4,
          //   width: 2,
          // )
        ],
      ),
    );
  }
}
