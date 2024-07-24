import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:intertravel/Util/Constrains.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:intertravel/ViewModel/GeminiProvider.dart';
import 'package:intertravel/theme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

import '../Model/Diary.dart';
import '../ViewModel/UserData.dart';
import 'AddNewDiaryPage.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late Diary diary;
  late List<Image> images;
  List<Uint8List> imageBytes = [];
  List<String> tags = [];

  Future<Uint8List?> loadImageAsUint8List(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to load image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }

  Future<void> _loadImage() async {
    for (var i = 0; i < diary.imageURI.length; i++) {
      final image = await loadImageAsUint8List(diary.imageURI[i]);
      if (image != null) {
        imageBytes.add(image);
      }
    }
  }

  @override
  void initState() {
    diary = Provider.of<DiaryProvider>(context, listen: false).selectedDiary!;
    GeminiProvider geminiProvider =
        Provider.of<GeminiProvider>(context, listen: false);
    geminiProvider.response = '';
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadImage();
      if (diary.tags == null || diary.tags!.isEmpty) {
        geminiProvider.requestPrompt(imageBytes, diary);
      }
    });
    super.initState();
    images = diary.imageURI.map((e) => Image.network(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          diary.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: const Text('수정'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNewDiaryPage(diary: diary),
                      ),
                    );
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('삭제'),
                  onTap: () {
                    Provider.of<DiaryProvider>(context, listen: false)
                        .deleteDiary(diary);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSlideshow(),
            _buildDateAndLocation(),
            _buildDivider(),
            _buildContent(),
            (diary.tags == null || diary.tags!.isEmpty)
                ? _buildAISuggestion()
                : _tagsView(),
          ],
        ),
      ),
    );
  }

  Widget _tagsView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: diary.tags!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        diary.tags![index],
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  );
                }),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Provider.of<DiaryProvider>(context, listen: false)
                    .updateDiaryTags(diary, []);
                _reloadPage();
              },
              child: Text(
                '태그 초기화하기',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _reloadPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => DiaryPage()),
    );
  }

  Widget _buildAISuggestion() {
    return Consumer<GeminiProvider>(builder: (context, geminiProvider, child) {
      if (geminiProvider.response == '') {
        return Center(
            child: Column(
          children: [
            LoadingAnimationWidget.waveDots(
                color: CustomTheme.light().highlightColor, size: 50),
            Text(
              "AI 태그 추천 중..."
              "\n네트워크 상태에 따라 시간이 걸릴 수 있습니다.",
              textAlign: TextAlign.center,
            ),
          ],
        ));
      }
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: geminiProvider.tags.background.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ToggleButtons(
                      isSelected: [geminiProvider.selectedBackgrounds[index]],
                      onPressed: (_) {
                        setState(() {
                          if (geminiProvider.selectedBackgrounds[index] ==
                              false) {
                            tags.add(geminiProvider.tags.background[index]);
                            geminiProvider.selectedBackgrounds[index] = true;
                          } else {
                            tags.remove(geminiProvider.tags.background[index]);
                            geminiProvider.selectedBackgrounds[index] = false;
                          }
                        });
                      },
                      color: Colors.blue,
                      selectedColor: Colors.white,
                      fillColor: Colors.blue,
                      borderColor: Colors.blue,
                      selectedBorderColor: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            geminiProvider.tags.background[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: geminiProvider.tags.keywords.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ToggleButtons(
                      isSelected: [geminiProvider.selectedKeywords[index]],
                      onPressed: (_) {
                        setState(() {
                          if (geminiProvider.selectedKeywords[index] == false) {
                            tags.add(geminiProvider.tags.keywords[index]);
                            geminiProvider.selectedKeywords[index] = true;
                            print('add');
                          } else {
                            tags.remove(geminiProvider.tags.keywords[index]);
                            geminiProvider.selectedKeywords[index] = false;
                          }
                          print(tags);
                        });
                      },
                      color: Colors.blue,
                      selectedColor: Colors.white,
                      fillColor: Colors.blue,
                      borderColor: Colors.blue,
                      selectedBorderColor: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            geminiProvider.tags.keywords[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Consumer<GeminiProvider>(builder: (context, geminiProvider, child) {
              if (geminiProvider.selectedBackgrounds.contains(true) ||
                  geminiProvider.selectedKeywords.contains(true)) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<DiaryProvider>(context, listen: false)
                              .updateDiaryTags(diary, tags);
                          Provider.of<UserData>(context, listen: false)
                              .addTag(tags);
                          _reloadPage();
                        },
                        child: Text(
                          '태그 저장하기',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }),
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                "태그 추천은 구글 Gemini AI를 통해 제공되고 있어요!\n가끔 오류가 발생할 수 있습니다.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildImageSlideshow() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ImageSlideshow(
        width: double.infinity,
        height: 300,
        initialPage: 0,
        indicatorColor: Colors.blue,
        indicatorBackgroundColor: Colors.grey,
        children: diary.imageURI.map((e) => _buildImageSlide(e)).toList(),
      ),
    );
  }

  Widget _buildImageSlide(String imageUrl) {
    return GestureDetector(
      onTap: () => _showFullScreenImage(imageUrl),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, size: 50, color: Colors.red),
      ),
    );
  }

  void _showFullScreenImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewDialog(imageURI: imageUrl),
      ),
    );
  }

  Widget _buildDateAndLocation() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatDate(diary.date),
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          if (diary.address != null && diary.address!.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  diary.address!,
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(thickness: 1, color: Colors.grey[300]);
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        diary.content,
        style: const TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }
}

class PhotoViewDialog extends StatelessWidget {
  final String imageURI;

  const PhotoViewDialog({Key? key, required this.imageURI}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(imageURI),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            errorBuilder: (context, error, stackTrace) =>
                const Center(child: Text('이미지를 불러오는 중 오류가 발생했습니다.')),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
