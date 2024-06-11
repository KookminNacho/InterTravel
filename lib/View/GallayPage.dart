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
  List<List> imageList = [];

  void getImage(DiaryProvider diaryProvider) {
    for (Diary diary in diaryProvider.diaries) {
      for (String imageURI in diary.imageURI) {
        imageList.add([imageURI, diary]);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    DiaryProvider diaryProvider =
        Provider.of<DiaryProvider>(context, listen: false);
    getImage(diaryProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("갤러리"),
        centerTitle: true,
        backgroundColor: Colors.black54,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black54,
      body: Consumer<DiaryProvider>(builder: (context, diaries, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: MasonryGridView.count(
            clipBehavior: Clip.none,
            itemCount: imageList.length,
            crossAxisCount:
                (MediaQuery.of(context).size.aspectRatio < 0.6) ? 2 : 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemBuilder: (context, index) {
              return KeepAliveDiaryCard(url: imageList[index]);
            },
          ),
        );
      }),
    );
  }
}

class KeepAliveDiaryCard extends StatefulWidget {
  final List url;

  const KeepAliveDiaryCard({Key? key, required this.url}) : super(key: key);

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
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Provider.of<DiaryProvider>(context, listen: false)
            .selectDiary(widget.url[1]);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colors[Random().nextInt(colors.length)],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.url[0],
                fit: BoxFit.cover,
                frameBuilder:
                    (buildContext, context, frame, wasSynchronouslyLoaded) {
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 500),
                    child: frame != null
                        ? Image.network(
                            widget.url[0],
                            fit: BoxFit.cover,
                          )
                        : const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
