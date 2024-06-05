import 'package:flutter/material.dart';
import 'package:intertravel/ViewModel/UIViewMode.dart';
import 'package:provider/provider.dart';

import '../../Util/Constrains.dart';
import '../../ViewModel/DiaryProvider.dart';

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
      body: Consumer<DiaryProvider>(builder: (context, diaries, child) {
        return ListView.builder(
          itemCount: diaries.diaries.length,
          itemBuilder: (context, index) {
            Image? imageData = Image.network(
              diaries.diaries[index].imageURI[0],
              fit: BoxFit.cover,
            );
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: BorderDirectional(
                  top: BorderSide(
                    color: Colors.black12,
                    width: 1,
                  ),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 75,
                    width: 75,
                    child: imageData,
                  ),
                ),
                title: Text(
                  diaries.diaries[index].title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      diaries.diaries[index].content,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDate(diaries.diaries[index].date),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () {
                  Provider.of<UIViewModel>(context, listen: false).bigWelcome();
                  diaries.selectDiary(diaries.diaries[index]);
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        );
      }),
    );
  }
}
