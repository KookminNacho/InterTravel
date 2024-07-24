import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intertravel/View/DiaryPage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../Model/Diary.dart';
import '../Util/Constrains.dart';
import '../ViewModel/DiaryProvider.dart';
import '../ViewModel/ImageProvider.dart';
import '../ViewModel/UserData.dart';
import 'View/DIalog/TravelSuggestionDialog.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Timer? _debounce;

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25.0),
      height: welcomeHeight + 50,
      child: Consumer<DiaryProvider>(
        builder: (context, diaryProvider, child) {
          return Selector<UserData, UserData?>(
            builder: (context, userData, child) {
              return Consumer<ImageProviderModel>(
                builder: (context, imageProvider, child) {
                  return DiaryListView(diaryProvider, userData!);
                },
              );
            },
            selector: (_, userData) => userData,
          );
        },
      ),
    );
  }

  Widget DiaryListView(DiaryProvider diaryProvider, UserData userData) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                showDialog(
                    context: context, builder: (context) => TagListDialog());
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userData.user!.photoURL!),
                    backgroundColor: Colors.transparent,
                    radius: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(userData.displayName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w100)),
                  ),
                ],
              ),
            ),
            Text(
              "마지막 일기: ${diaryProvider.diaries.isNotEmpty ? DateFormat('yyyy년 MM월 dd일').format(diaryProvider.diaries.first.date) : "없음"}",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '최근 일기',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                _buildAIRecommendationButton(diaryProvider, userData),
              ],
            ),
          ),
          Expanded(
            child: _buildDiaryPageView(diaryProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildAIRecommendationButton(
      DiaryProvider diaryProvider, UserData userData) {
    return ElevatedButton.icon(
      onPressed: () {
        if (diaryProvider.isLoaded) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("AI 여행 추천"),
              content: const SizedBox(
                height: 500,
                child: TravelSuggestionDialog(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("확인"),
                ),
              ],
            ),
          );
        }
      },
      icon: const Icon(Icons.lightbulb_outline),
      label: const Text("AI 추천"),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildDiaryPageView(DiaryProvider diaryProvider) {
    return diaryProvider.isLoaded
        ? Stack(
            children: [
              PageView.builder(
                onPageChanged: (index) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    diaryProvider.selectDiary(diaryProvider.diaries[index]);
                  });
                },
                controller: diaryProvider.pageController,
                itemCount: diaryProvider.diaries.length,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) => _buildDiaryCard(
                    diaryProvider.diaries[index], diaryProvider),
              ),
              _buildPageNavigationOverlay(diaryProvider),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget _buildDiaryCard(Diary diary, DiaryProvider diaryProvider) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: InkWell(
            onTap: () {
              diaryProvider.selectDiary(diary);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const DiaryPage()));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: diary.imageURI.isNotEmpty
                      ? Image.network(
                          diary.imageURI[0],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          cacheHeight: 1024,
                        )
                      : Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[300],
                          child: Icon(Icons.image,
                              size: 50, color: Colors.grey[600]),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        diary.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        diary.content,
                        style: const TextStyle(fontSize: 16),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('yyyy년 MM월 dd일 HH:mm').format(diary.date),
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
  }

  Widget _buildPageNavigationOverlay(DiaryProvider diaryProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _moveToPreviousPage(diaryProvider),
          child: Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width / 5,
          ),
        ),
        GestureDetector(
          onTap: () => _moveToNextPage(diaryProvider),
          child: Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width / 5,
          ),
        ),
      ],
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

class TagListDialog extends StatefulWidget {
  const TagListDialog({super.key});

  @override
  State<TagListDialog> createState() => _TagListDialogState();
}

class _TagListDialogState extends State<TagListDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("관심 태그"),
      content: Consumer<UserData>(
        builder: (context, userData, child) {
          return Wrap(
            children: userData.tags.map((tag) => _buildTagChip(tag)).toList(),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("확인"),
        ),
      ],
    );
  }

  Widget _buildTagChip(String tag) {
    return Chip(
      label: Text(tag),
      onDeleted: () {
        Provider.of<UserData>(context, listen: false).removeTag(tag);
      },
    );
  }
}
