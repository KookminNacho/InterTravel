import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intertravel/View/DiaryPage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../Model/Diary.dart';
import '../Util/Constrains.dart';
import '../View/AddNewDiaryPage.dart';
import '../ViewModel/DiaryProvider.dart';
import '../ViewModel/ImageProvider.dart';
import '../ViewModel/UserData.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Timer? _debounce;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25.0),
      height: welcomeHeight + 50,
      child: Consumer<DiaryProvider>(
        builder: (context, diaryProvider, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {});
          return Selector<UserData, User?>(
            builder: (context, userData, child) {
              return Consumer<ImageProviderModel>(
                builder: (context, imageProvider, child) {
                  return DiaryListView(diaryProvider, userData!);
                },
              );
            },
            selector: (_, userData) => userData.user,
          );
        },
      ),
    );
  }

  Widget DiaryListView(DiaryProvider diaryProvider, User userData) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userData.photoURL!),
                  backgroundColor: Colors.transparent,
                  radius: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${userData.displayName}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w100)),
                ),
              ],
            ),
            Text(
                "마지막 일기: ${diaryProvider.diaries.isNotEmpty ? DateFormat('yyyy년 MM월 dd일').format(diaryProvider.diaries.first.date) : "없음"}"),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Flexible(
              fit: FlexFit.loose,
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '최근 일기',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: (diaryProvider.isLoaded)
                  ? Stack(
                      children: [
                        PageView.builder(
                          onPageChanged: (index) async {
                            if (_debounce?.isActive ?? false) _debounce!.cancel();
                            _debounce = Timer(const Duration(milliseconds: 500), () {
                              diaryProvider.selectDiary(diaryProvider.diaries[index]);
                            });
                          },
                          controller: diaryProvider.pageController,
                          itemCount: diaryProvider.diaries.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            Diary diary = diaryProvider.diaries[index];
                            return SingleChildScrollView(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      diaryProvider.selectDiary(diary);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DiaryPage(),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(15)),
                                          child: diary.imageURI.isNotEmpty
                                              ? Image.network(
                                                  cacheHeight: 1024,
                                                  diary.imageURI[0],
                                                  height: 150,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  width: double.infinity,
                                                  height: 150,
                                                  color: Colors.grey[300],
                                                  child: Icon(Icons.image,
                                                      size: 50,
                                                      color: Colors.grey[600]),
                                                ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                diary.title,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                diary.content,
                                                style: TextStyle(fontSize: 14),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                DateFormat('yyyy년 MM월 dd일 h시')
                                                    .format(diary.date),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  color: Colors.transparent,
                                  width: MediaQuery.of(context).size.width / 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      _moveToPreviousPage(diaryProvider);
                                    },
                                  )),
                              Container(
                                  color: Colors.transparent,
                                  width: MediaQuery.of(context).size.width / 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      _moveToNextPage(diaryProvider);
                                    },
                                  )),
                            ])
                      ],
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }

  void _moveToNextPage(DiaryProvider diaryProvider) {
    diaryProvider.pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _moveToPreviousPage(DiaryProvider diaryProvider) {
    diaryProvider.pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
