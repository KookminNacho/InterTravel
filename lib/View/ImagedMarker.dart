import 'package:flutter/material.dart';

import '../Model/Diary.dart';

class ImagedMarker extends StatefulWidget {
  final Diary diary;

  const ImagedMarker({super.key, required this.diary});

  @override
  State<ImagedMarker> createState() => _ImagedMarkerState();
}

class _ImagedMarkerState extends State<ImagedMarker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedContainer(
        height: 50,
        duration: Duration(milliseconds: 300),
        child: GestureDetector(
          onTap: () {
            print("tapped");
          },
          child: Column(
            children: [
              Container(
                  height: 40,
                  width: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Text(
                    widget.diary.title,
                    style: const TextStyle(color: Colors.black, fontSize: 10),
                  )),
              Container(
                color: Colors.grey,
                height: 4,
                width: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
