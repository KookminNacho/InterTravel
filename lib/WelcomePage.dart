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
  PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25.0),
      height: welcomeHeight + 50,
      child: Consumer<DiaryProvider>(
        builder: (context, diaryProvider, child) {
          if (diaryProvider.selectedDiary != null) {
            _pageController.animateToPage(
                diaryProvider.diaries.indexOf(diaryProvider.selectedDiary!),
                duration: const Duration(milliseconds: 1),
                curve: Curves.easeIn);
          }
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
                Text('${userData.displayName}',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                CircleAvatar(
                  backgroundImage: NetworkImage(userData.photoURL!),
                  backgroundColor: Colors.transparent,
                  radius: 15,
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: (diaryProvider.isLoaded)
                  ? PageView.builder(
                      onPageChanged: (index) {
                        diaryProvider.selectDiary(diaryProvider.diaries[index]);
                      },
                      controller: _pageController,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15)),
                                      child: diary.imageURI.isNotEmpty
                                          ? Image.network(
                                              cacheHeight: 1024,
                                              diary.imageURI[0],
                                              height: 200,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: double.infinity,
                                              height: 200,
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
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            diary.content,
                                            style: TextStyle(fontSize: 14),
                                            maxLines: 3,
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
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
