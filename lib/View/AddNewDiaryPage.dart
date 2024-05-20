import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
    // TODO: implement initState
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
      appBar: AppBar(
        title: const Text("새 일기"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "제목을 입력해주세요",
                ),
              ),
              Expanded(
                child: TextField(
                  controller: contentController,
                  maxLines: 20,
                  decoration: InputDecoration(
                    hintText: "내용을 입력해주세요",
                  ),
                ),
              ),
              Container(
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: file.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      print("file length: ${file.length}");
                      if (file.isEmpty) {
                        return MaterialButton(
                            onPressed: () async {
                              XFile? image = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (image == null) return;
                              print("이미지 추가: ${image.path}");
                              setState(() {
                                file.add(image.path);
                              });
                            },
                            child: const Icon(Icons.add));
                      } else {
                        if (index != file.length) {
                          if (file[index].contains(
                              "https://firebasestorage.googleapis.com/v0/b/intertravel-fab82.appspot")) {
                            return Image.network(file[index]);
                          }
                          return Image.file(File(file[index]));
                        }
                        return MaterialButton(
                            onPressed: () async {
                              XFile? image = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (image == null) return;
                              print("이미지 추가: ${image.path}");
                              setState(() {
                                file.add(image.path);
                              });
                            },
                            child: const Icon(Icons.add));
                      }
                    }),
              ),
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
                                content: Text(
                                    "저장하시겠습니까? 일기 ID: ${widget.diary?.uid}"),
                                actions: [
                                  MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("취소")),
                                  MaterialButton(
                                      onPressed: () {
                                        uploadImage(userData);
                                      },
                                      child: const Text("확인")),
                                ],
                              );
                            });
                      },
                      child: Text("저장하기")),
                  MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("나가기")),
                ],
              )
            ]),
          ),
        ],
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
        userID: userData.displayName);

    List<String> imageUri =
        await Provider.of<ImageProviderModel>(context, listen: false)
            .upLoadImage(userData, file, diary);
    diary.imageURI = imageUri;
    for(int i = 0; i < imageUri.length; i++){
      print("imageUri: ${imageUri[i]}");
    }
    if (widget.diary != null) {
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
