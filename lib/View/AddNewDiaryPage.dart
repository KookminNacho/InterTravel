import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../Model/Diary.dart';
import '../ViewModel/ImageProvider.dart';
import '../ViewModel/UserData.dart';

class AddNewDiaryPage extends StatefulWidget {
  const AddNewDiaryPage({super.key});

  @override
  State<AddNewDiaryPage> createState() => _AddNewDiaryPageState();
}

class _AddNewDiaryPageState extends State<AddNewDiaryPage> {
  List<File> file = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool imageUploaded = false;

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
                      if (file.isEmpty) {
                        return MaterialButton(
                            onPressed: () async {
                              XFile? image = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (image == null) return;
                              print("이미지 추가: ${image.path}");
                              setState(() {
                                file.add(File(image.path));
                              });
                            },
                            child: const Icon(Icons.add));
                      } else {
                        if (index != file.length) {
                          return Image.file(file[index]);
                        }
                        return MaterialButton(
                            onPressed: () async {
                              XFile? image = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (image == null) return;
                              print("이미지 추가: ${image.path}");
                              setState(() {
                                file.add(File(image.path));
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
                                content: const Text("저장하시겠습니까?"),
                                actions: [
                                  MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("취소")),
                                  MaterialButton(
                                      onPressed: () async {
                                        UserData userData =
                                            Provider.of<UserData>(context,
                                                listen: false);

                                        Diary diary = Diary(
                                            title: titleController.text,
                                            content: contentController.text,
                                            imageURI: [],
                                            date: DateTime.now(),
                                            location: userData.location!,
                                            owner: userData.uid,
                                            userID: userData.displayName);

                                        List<String> imageUri = await Provider
                                                .of<ImageProviderModel>(context,
                                                    listen: false)
                                            .upLoadImage(file, diary);
                                        diary.imageURI = imageUri;
                                        Provider.of<DiaryProvider>(context,
                                                listen: false)
                                            .addDiary(diary, userData);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
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
}
