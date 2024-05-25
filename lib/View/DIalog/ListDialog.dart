import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intertravel/ViewModel/UIViewMode.dart';
import 'package:provider/provider.dart';

import '../../Util/Constrains.dart';
import '../../ViewModel/DiaryProvider.dart';
import '../../ViewModel/ImageProvider.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기 목록'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Consumer<DiaryProvider>(builder: (context, diaries, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: diaries.diaries.length,
                  itemBuilder: (context, index) {
                    Image? imageData = Image.network(
                        fit: BoxFit.fitWidth,
                        diaries.diaries[index].imageURI[0]!);
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
