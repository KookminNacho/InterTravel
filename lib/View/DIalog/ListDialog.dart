import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intertravel/ViewModel/UIViewMode.dart';
import 'package:provider/provider.dart';

import '../../Util/Constrains.dart';
import '../../ViewModel/DiaryProvider.dart';
import '../../ViewModel/ImageProvider.dart';

class ListDialog extends StatefulWidget {
  const ListDialog({super.key});

  @override
  State<ListDialog> createState() => _ListDialogState();
}

class _ListDialogState extends State<ListDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetAnimationDuration: const Duration(milliseconds: 1000),
      surfaceTintColor: Colors.white,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Consumer<DiaryProvider>(builder: (context, diaries, child) {
          return Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  Container(
                    height: 50,
                    child: const Center(
                      child: Text('일기 목록'),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: diaries.diaries.length,
                  itemBuilder: (context, index) {
                    Image? imageData = Image.network(
                        fit: BoxFit.fitWidth,diaries.diaries[index].imageURI[0]!);
                    return ListTile(
                        leading: SizedBox(
                          height: 75,
                          width: 75,
                          child: (imageData != null) ? imageData : Container(),
                        ),
                        title: Text(
                          diaries.diaries[index].title,
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: Column(
                          children: [
                            Text(
                              diaries.diaries[index].content,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "${formatDate(diaries.diaries[index].date)}",
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Provider.of<UIViewModel>(context, listen: false)
                              .bigWelcome();
                          diaries.selectDiary(diaries.diaries[index]);
                          Navigator.of(context).pop();
                        });
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
