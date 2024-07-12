import 'package:flutter/material.dart';
import 'package:intertravel/theme.dart';
import 'package:provider/provider.dart';

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
    DiaryProvider diaryProvider = Provider.of<DiaryProvider>(context);
    Diary? lateDiary =
        (diaryProvider.isLoaded && diaryProvider.diaries.isNotEmpty)
            ? diaryProvider.diaries.first
            : null;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
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
                ? const Center(child: Text("일기가 없습니다."))
                : ClipRect(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 130.0),
                      child: GridView.builder(
                          clipBehavior: Clip.none,
                          physics: const ClampingScrollPhysics(),
                          cacheExtent: 9999,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 300,
                            crossAxisCount: 2,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          itemCount: diaries.diaries.length,
                          itemBuilder: (context, index) {
                            return DiaryEntryCard(
                                diary: diaries.diaries[index]);
                          }),
                    ),
                  );
          }),
        ),
        Container(
          height: 120,
          decoration: BoxDecoration(
              color: CustomTheme.light().scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 4),
                )
              ]),
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    Provider.of<UserData>(context).displayName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 8.0),
                    child: ((diaryProvider.diaries.isNotEmpty &&
                            diaryProvider.isLoaded &&
                            lateDiary != null))
                        ? RichText(
                            textAlign: TextAlign.right,
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: '마지막 일기: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                TextSpan(
                                  text: "${lateDiary.title}\n",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '${formatDate(lateDiary.date)}\n',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${timeDifference(lateDiary.date)}에 작성됨',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Text(""),
                  ),
                ),
              ),
            ],
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

class _DiaryEntryCardState extends State<DiaryEntryCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: InkWell(
        onTap: () {
          Provider.of<DiaryProvider>(context, listen: false)
              .selectDiary(widget.diary);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: widget.diary.imageURI.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.diary.imageURI[0],
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.diary.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  maxLines: 1,
                  widget.diary.content,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
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
