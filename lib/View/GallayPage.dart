import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:provider/provider.dart';

import '../Model/Diary.dart';

class GallaryPage extends StatefulWidget {
  const GallaryPage({super.key});

  @override
  State<GallaryPage> createState() => _GallaryPageState();
}

class _GallaryPageState extends State<GallaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: const Text('갤러리'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Consumer<DiaryProvider>(builder: (context, diaries, child) {
              print(
                  "Screen Aspects: ${MediaQuery.of(context).size.aspectRatio}");
              return Expanded(
                  child: MasonryGridView.count(
                itemCount: diaries.diaries.length,
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  return DiaryCard(diaries.diaries[index]);
                },
              ));
            }),
          ],
        ),
      ),
    );
  }

  Widget DiaryCard(Diary diary) {
    return Column(
      children: [
        Image.network(
          diary.imageURI[0],
          fit: BoxFit.cover,
          frameBuilder: (BuildContext, context, frame, wasSynchronouslyLoaded) {
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Container(
                      child: frame != null
                          ? Image.network(
                              diary.imageURI[0],
                              fit: BoxFit.cover,
                            )
                          : CircularProgressIndicator(),
                    ),

                    Text(diary.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
