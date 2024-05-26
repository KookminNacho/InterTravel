import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../Model/Diary.dart';
import '../Util/Constrains.dart';
import '../ViewModel/DiaryProvider.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Consumer<DiaryProvider>(builder: (context, diaries, child) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: MasonryGridView.count(
                clipBehavior: Clip.none,
                itemCount: diaries.diaries.length,
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemBuilder: (context, index) {
                  return KeepAliveDiaryCard(diary: diaries.diaries[index]);
                },
              ),
            ),
            Container(
              child: Row(children: [
                BackButton( onPressed: () {
                  Navigator.pop(context);
                },),
              ],),
              color: Colors.white,
              height: 100,
            ),
          ],
        );
      }),
    );
  }
}

class KeepAliveDiaryCard extends StatefulWidget {
  final Diary diary;

  const KeepAliveDiaryCard({Key? key, required this.diary}) : super(key: key);

  @override
  _KeepAliveDiaryCardState createState() => _KeepAliveDiaryCardState();
}

class _KeepAliveDiaryCardState extends State<KeepAliveDiaryCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;




  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colors[Random().nextInt(colors.length)],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Image.network(

                widget.diary.imageURI[0],

                fit: BoxFit.cover,
                frameBuilder:
                    (BuildContext, context, frame, wasSynchronouslyLoaded) {
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 500),
                    child: frame != null
                        ? Image.network(
                            widget.diary.imageURI[0],
                            fit: BoxFit.cover,
                          )
                        : const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
              Text(widget.diary.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ],
    );
  }
}
