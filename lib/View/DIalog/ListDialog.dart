import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intertravel/ViewModel/UIViewMode.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
      surfaceTintColor: Colors.white,
      child: Consumer<DiaryProvider>(builder: (context, diaries, child) {
        return Column(
          children: [
            Container(
              height: 50,
              child: const Center(
                child: Text('일기 목록'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: diaries.diaries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      leading: SizedBox(
                        height: 75,
                        width: 75,
                        child: Image.memory(
                            fit: BoxFit.fitWidth,
                            Provider.of<ImageProviderModel>(context,
                                        listen: false)
                                    .images[
                                diaries.diaries[index].imageURI[0]]![0]),
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
                            "${_formatDate(diaries.diaries[index].date)}",
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
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy년 MM월 dd일 hh:mm').format(date);
  }
}
