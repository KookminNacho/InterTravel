import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intertravel/Util/Constrains.dart';
import 'package:provider/provider.dart';

import '../ViewModel/DiaryProvider.dart';

class RandomStackPhoto extends StatefulWidget {
  const RandomStackPhoto({super.key});

  @override
  State<RandomStackPhoto> createState() => _RandomStackPhotoState();
}

class _RandomStackPhotoState extends State<RandomStackPhoto> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryProvider>(builder: (context, diaryProvider, child) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 50, 50, 50),
              border: Border.all(color: Colors.black12, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(-2, 2),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.width *
                0.45 /
                MediaQuery.of(context).size.aspectRatio *
                0.65,
            width: MediaQuery.of(context).size.width * 0.65,
            child: Text(
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w100),
              diaryProvider.selectedDiary!.content,
              textAlign: TextAlign.center,
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: List.generate(
              diaryProvider.selectedDiary!.imageURI.length,
              (index) {
                Image image = Image.network(
                  cacheWidth: MediaQuery.of(context).size.width.toInt(),
                  key: ValueKey(diaryProvider.selectedDiary!.imageURI[index]),
                  diaryProvider.selectedDiary!.imageURI[index],
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    return AnimatedContainer(
                      width: MediaQuery.of(context).size.width * 0.65,
                      padding: const EdgeInsets.all(8),
                      // 이미지 크기보다 5 크게
                      color: Colors.blue,
                      transform: Matrix4.identity()
                        ..rotateZ(
                          photoAngleSpread[index],
                        )
                        ..translate(photoPositionSpread[index][0],
                            photoPositionSpread[index][1]),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      child: AnimatedOpacity(
                        child: child,
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      ),
                    );
                  },
                );
                return Positioned(
                  child: image,
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
