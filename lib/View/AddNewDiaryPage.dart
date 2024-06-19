import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intertravel/DataSource/NaverGeoCoder.dart';
import 'package:intertravel/View/DIalog/CustomLocationDialog.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:intertravel/ViewModel/UIViewMode.dart';
import 'package:intertravel/theme.dart';
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
  late UserData userDatas;
  String errorText = "";

  @override
  void initState() {
    super.initState();
    if (widget.diary != null) {
      titleController.text = widget.diary!.title;
      contentController.text = widget.diary!.content;
      file = widget.diary!.imageURI;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userDatas = Provider.of<UserData>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    const int contentMaxLength = 50;
    const int contentMaxLine = 50;

    ScrollController _scrollController = ScrollController();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(

        bottomNavigationBar: const Padding(
          padding: EdgeInsets.only(bottom: 32),
        ),
        appBar: AppBar(
          title: const Text("새 일기"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "제목을 입력해주세요",
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (String value) {
                    if (contentController.value.text.split('\n').length >
                        contentMaxLine) {
                      contentController.text = contentController.text
                          .substring(0, contentController.text.length - 1);
                      errorText = "최대 $contentMaxLine줄 까지 입력 가능해요.";
                    } else {
                      errorText = "";
                    }
                  },
                  controller: contentController,
                  minLines: 5,
                  maxLines: 10,
                  maxLength: contentMaxLength,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  buildCounter: (BuildContext context,
                          {required int currentLength,
                          required bool isFocused,
                          required int? maxLength}) =>
                      Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedContainer(
                        width: errorText.isEmpty ? 0 : 200,
                        duration: const Duration(milliseconds: 1000),
                        child: Text(
                          errorText,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: " $currentLength",
                              style: TextStyle(
                                color: (currentLength != maxLength)
                                    ? CustomTheme.dark()
                                        .textTheme
                                        .bodyLarge
                                        ?.color
                                    : CustomTheme.dark().colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "/$maxLength",
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: const InputDecoration(
                    labelText: "내용을 입력해주세요",
                  ),
                ),
                Consumer<UserData>(builder: (context, userData, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: NaverGeoCoder.getCityName(
                            (userData.selectedLocation == null)
                                ? userData.location!
                                : userData.selectedLocation!),
                        builder: (BuildContext context,
                            AsyncSnapshot<String?> snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  (userData.selectedLocation == null)
                                      ? const Text("현재 위치: ")
                                      : const Text("설정 위치: "),
                                  SizedBox(
                                    width: 200,
                                    child: AutoSizeText(
                                      snapshot.data.toString(),
                                      minFontSize: 10,
                                      maxFontSize: 14,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text("현재 위치를 불러오는 중입니다."),
                          );
                        },
                      ),
                      IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            setCustomLocation(userData.location!);
                          },
                          icon: const Icon(Icons.map_outlined, size: 14)),
                      IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            userData.selectedLocation = null;
                          },
                          icon:
                              const Icon(Icons.location_on_outlined, size: 14)),
                    ],
                  );
                }),
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
                        FocusScope.of(context).unfocus();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("저장"),
                              content: (widget.diary == null)
                                  ? Text("저장하시겠습니까?")
                                  : Text("수정하시겠습니까?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    FocusScope.of(context).unfocus();
                                  },
                                  child: const Text("취소"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    uploadImage(Provider.of<UserData>(context,
                                        listen: false));
                                    // 키보드 닫기
                                    FocusScope.of(context).unfocus();
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
          FocusScope.of(context).unfocus();
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
    print("추가된 주소 이름: ${diary.address}");
    Provider.of<UIViewModel>(context, listen: false).setFirstLoad(true);

    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    userDatas.selectedLocation = null;

    // TODO: implement dispose
    super.dispose();
  }
}
