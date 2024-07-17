import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intertravel/DataSource/NaverGeoCoder.dart';
import 'package:intertravel/View/DIalog/CustomLocationDialog.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:intertravel/ViewModel/UIViewMode.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../Model/Diary.dart';
import '../ViewModel/ImageProvider.dart';
import '../ViewModel/UserData.dart';

class AddNewDiaryPage extends StatefulWidget {
  const AddNewDiaryPage({super.key, this.diary});

  final Diary? diary;

  @override
  State<AddNewDiaryPage> createState() => _AddNewDiaryPageState();
}

class _AddNewDiaryPageState extends State<AddNewDiaryPage> {
  List<String> file = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool imageUploaded = false;
  String errorText = "";
  NLatLng? originalLocation;
  String? originalAddress;

  @override
  void initState() {
    if (widget.diary != null) {
      titleController.text = widget.diary!.title;
      contentController.text = widget.diary!.content;
      file = widget.diary!.imageURI;
      Provider.of<UserData>(context, listen: false)
          .selectedLocation = widget.diary!.location;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.diary == null ? "새 일기" : "일기 수정"),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleField(),
              const SizedBox(height: 16),
              _buildContentField(),
              const SizedBox(height: 24),
              _buildLocationInfo(),
              const SizedBox(height: 24),
              _buildImageGallery(),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: titleController,
      decoration: InputDecoration(
        labelText: "제목",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildContentField() {
    return TextFormField(
      controller: contentController,
      maxLines: 8,
      maxLength: 500,
      decoration: InputDecoration(
        labelText: "내용",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Consumer<UserData>(
      builder: (context, userData, child) {
        return FutureBuilder<String?>(
          future: NaverGeoCoder.getCityName(
            userData.selectedLocation ?? userData.location!,
          ),
          builder: (context, snapshot) {
            return Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: (snapshot.connectionState == ConnectionState.waiting)
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            snapshot.data ?? "위치 정보 없음",
                            style: TextStyle(color: Colors.blue[700]),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_location),
                          onPressed: () =>
                              setCustomLocation(userData.location!),
                        ),
                      ],
                    ),
            );
          },
        );
      },
    );
  }

  Widget _buildImageGallery() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: file.length + 1,
        itemBuilder: (context, index) {
          if (index == file.length) {
            return _buildAddButton();
          } else {
            return _buildImage(index);
          }
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: const Icon(Icons.add_photo_alternate, size: 30),
        onPressed: () async {
          List<XFile> imageList = await ImagePicker().pickMultiImage();
          if (imageList.isNotEmpty) {
            setState(() {
              file.addAll(imageList.map((img) => img.path));
            });
          }
        },
      ),
    );
  }

  Widget _buildImage(int index) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: file[index].contains("https://")
            ? Image.network(file[index], fit: BoxFit.cover)
            : Image.file(File(file[index]), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (titleController.text == "" &&
                contentController.text == "" &&
                file.isEmpty) {
              Navigator.pop(context);
              return;
            }
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("일기 작성 취소"),
                  content: const Text("저장하지 않고 나가시겠습니까?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                      },
                      child: const Text("취소"),
                    ),
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "나가기",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text("그만두기"),
        ),
        ElevatedButton(
          onPressed: () => _showSaveConfirmDialog(),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text("저장하기"),
        ),
      ],
    );
  }

  void _showSaveConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.diary == null ? "저장" : "수정"),
        content: Text(widget.diary == null ? "저장하시겠습니까?" : "수정하시겠습니까?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              uploadImage(Provider.of<UserData>(context, listen: false));
            },
            child: const Text("저장"),
          ),
        ],
      ),
    );
  }

  void setCustomLocation(NLatLng location) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomLocationDialog();
        });
  }

  void uploadImage(UserData userData) async {
    Diary diary = Diary(
      uid: "local",
      title: titleController.text,
      content: contentController.text,
      imageURI: [],
      date: DateTime.now(),
      location: userData.selectedLocation ?? userData.location!,
      owner: userData.uid,
      userID: userData.displayName,
      address: await NaverGeoCoder.getCityName(
          userData.selectedLocation ?? userData.location!),
    );

    List<String> imageUri =
        await Provider.of<ImageProviderModel>(context, listen: false)
            .upLoadImage(userData, file, diary);
    diary.imageURI = imageUri;
    if (widget.diary != null) {
      diary.address = widget.diary!.address;
      diary.address = await NaverGeoCoder.getCityName(userData.selectedLocation ?? userData.location!);
      diary.uid = widget.diary!.uid;
      diary.date = widget.diary!.date;
      diary.location = userData.selectedLocation ?? userData.location!;
      Provider.of<DiaryProvider>(context, listen: false)
          .updateDiary(widget.diary!, diary, userData);
      Provider.of<DiaryProvider>(context, listen: false).selectDiary(diary);
      print("수정된 주소 이름: ${diary.address}");
    } else {
      Provider.of<DiaryProvider>(context, listen: false)
          .addDiary(diary, userData);
    }
    print("추가된 주소 이름: ${diary.address}");
    Provider.of<UIViewModel>(context, listen: false).setFirstLoad(true);
    Navigator.popUntil(context, (route) => route.isFirst);

  }
}
