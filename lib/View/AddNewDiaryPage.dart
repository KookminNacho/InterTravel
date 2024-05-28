import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intertravel/DataSource/NaverGeoCoder.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:intertravel/ViewModel/UIViewMode.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../Model/Diary.dart';
import '../ViewModel/ImageProvider.dart';
import '../ViewModel/UserData.dart';

class AddNewDiaryPage extends StatefulWidget {
  AddNewDiaryPage({super.key, this.diary});

  Diary? diary;

  @override
  State<AddNewDiaryPage> createState() => _AddNewDiaryPageState();
}

class _AddNewDiaryPageState extends State<AddNewDiaryPage> {
  List<String> file = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool imageUploaded = false;
  late UserData userData;

  @override
  void initState() {
    super.initState();
    userData = Provider.of<UserData>(context, listen: false);
    if (widget.diary != null) {
      titleController.text = widget.diary!.title;
      contentController.text = widget.diary!.content;
      file = widget.diary!.imageURI;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 32),
      ),
      appBar: AppBar(
        title: const Text("새 일기"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "제목을 입력해주세요",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  labelText: "내용을 입력해주세요",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            FutureBuilder(
              future: NaverGeoCoder.getCityName(userData.location!),
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text("현재 위치: ${snapshot.data}"),
                  );
                }
                return const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text("현재 위치를 불러오는 중입니다."),
                );
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: file.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == file.length) {
                    return _buildAddButton();
                  } else {
                    return _buildImage(index);
                  }
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("저장"),
                          content:
                              Text("저장하시겠습니까? 일기 ID: ${widget.diary?.uid}"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("취소"),
                            ),
                            TextButton(
                              onPressed: () {
                                uploadImage(userData);
                              },
                              child: const Text("확인"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("저장하기"),
                ),
                MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("일기 작성 취소"),
                            content: const Text("저장하지 않고 나가시겠습니까?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("취소"),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "나가기",
                                    style: TextStyle(color: Colors.red),
                                  )),
                            ],
                          );
                        });
                  },
                  child: const Text("그만두기"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: MaterialButton(
        onPressed: () async {
          List<XFile> imageList = await ImagePicker().pickMultiImage();
          if (imageList.isNotEmpty) {
            setState(() {
              for (XFile img in imageList) {
                file.add(img.path);
              }
            });
          }
        },
        child: const Icon(Icons.add, size: 35),
      ),
    );
  }

  Widget _buildImage(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: file[index].contains(
                "https://firebasestorage.googleapis.com/v0/b/intertravel-fab82.appspot")
            ? Image.network(
                file[index],
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  }
                },
              )
            : Image.file(File(file[index])),
      ),
    );
  }

  void uploadImage(UserData userData) async {
    Diary diary = Diary(
      uid: "local",
      title: titleController.text,
      content: contentController.text,
      imageURI: [],
      date: DateTime.now(),
      location: userData.location!,
      owner: userData.uid,
      userID: userData.displayName,
      address: await NaverGeoCoder.getCityName(userData.location!),
    );

    List<String> imageUri =
        await Provider.of<ImageProviderModel>(context, listen: false)
            .upLoadImage(userData, file, diary);
    diary.imageURI = imageUri;
    if (widget.diary != null) {
      diary.address = widget.diary!.address;
      if (diary.address == "") {
        diary.address = await NaverGeoCoder.getCityName(userData.location!);
      }
      diary.uid = widget.diary!.uid;
      diary.date = widget.diary!.date;
      diary.location = widget.diary!.location;
      Provider.of<DiaryProvider>(context, listen: false)
          .updateDiary(widget.diary!, diary, userData);
      Provider.of<DiaryProvider>(context, listen: false).selectDiary(diary);
    } else {
      Provider.of<DiaryProvider>(context, listen: false)
          .addDiary(diary, userData);
    }
    Provider.of<UIViewModel>(context, listen: false).setFirstLoad(true);

    Navigator.pop(context);
    Navigator.pop(context);
  }
}
