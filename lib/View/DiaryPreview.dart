import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';

import '../DataSource/NaverGeoCoder.dart';
import '../Model/Diary.dart';
import '../Util/Constrains.dart';
import '../ViewModel/DiaryProvider.dart';
import '../ViewModel/UserData.dart';

class DiaryPreView extends StatefulWidget {
  const DiaryPreView({super.key});

  @override
  State<DiaryPreView> createState() => _DiaryPreViewState();
}

class _DiaryPreViewState extends State<DiaryPreView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 0,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: -1,
                blurRadius: 2,
                offset: const Offset(0, 4),
              ),
            ]),
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      Provider.of<UserData>(context).displayName ?? "User Name",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 8.0),
                      child: Text(
                        (Provider.of<DiaryProvider>(context).diaries.length >
                                    0 &&
                                Provider.of<DiaryProvider>(context).isLoaded)
                            ? '마지막 일기: ${formatDate(Provider.of<DiaryProvider>(context).diaries.last.date)}\n${Provider.of<DiaryProvider>(context).diaries.last.title}'
                            : '',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: Consumer<DiaryProvider>(builder: (context, diaries, child) {
              if (!diaries.isLoaded) {
                return const Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      "일기를 불러오는 중입니다...",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ));
              }
              return diaries.diaries.isEmpty && diaries.isLoaded
                  ? Center(child: Text("일기가 없습니다."))
                  : GridView.builder(
                      cacheExtent: 9999,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 300,
                        crossAxisCount: 2,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: diaries.diaries.length,
                      itemBuilder: (context, index) {
                        return DiaryEntryCard(diary: diaries.diaries[index]);
                      });
            }),
          ),
        ),
      ],
    );
  }
}

class DiaryEntryCard extends StatefulWidget {
  final Diary diary;

  const DiaryEntryCard({Key? key, required this.diary}) : super(key: key);

  @override
  State<DiaryEntryCard> createState() => _DiaryEntryCardState();
}

class _DiaryEntryCardState extends State<DiaryEntryCard> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      color: Color.fromARGB(255, 242, 249, 254),
      child: InkWell(
        onTap: () {
          Provider.of<DiaryProvider>(context, listen: false).selectDiary(widget.diary);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: widget.diary.imageURI.isNotEmpty
                    ? Image.network(
                        widget.diary.imageURI[0],
                        fit: BoxFit.fitWidth,
                      )
                    : Container(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.diary.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.diary.content,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
