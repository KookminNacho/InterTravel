import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:intertravel/Util/Constrains.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:intertravel/ViewModel/ImageProvider.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../Model/Diary.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageWState();
}

class _DiaryPageWState extends State<DiaryPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Diary diary;
  late List<Image> images;

  @override
  void initState() {
    diary = Provider.of<DiaryProvider>(context, listen: false).selectedDiary!;
    images = diary.imageURI.map((e) => Image.network(e)).toList();

    WidgetsBinding.instance!.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: AutoSizeText(
                    diary.title,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: Container(
                    height: 500,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                      child: Center(
                        child: Column(
                          children: [
                            Flexible(
                                flex: 1,
                                child: Text(formatDate(diary.date),
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey))),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ImageSlideshow(
                                height: MediaQuery.of(context).size.width * 0.6,
                                width: MediaQuery.of(context).size.width * 0.8,
                                initialPage: 0,
                                indicatorBottomPadding: 16,
                                children: diary.imageURI
                                    .map((e) => Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 36.0),
                                          child:
                                              images[diary.imageURI.indexOf(e)],
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: Text('${diary.content}',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Go Back'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
