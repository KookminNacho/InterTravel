import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:intertravel/Util/Constrains.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../Model/Diary.dart';
import 'AddNewDiaryPage.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late Diary diary;
  late List<Image> images;

  @override
  void initState() {
    super.initState();
    diary = Provider.of<DiaryProvider>(context, listen: false).selectedDiary!;
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
                    Provider.of<DiaryProvider>(context, listen: false).deleteDiary(diary);
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
          ],
        ),
      ),
    );
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