import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../Model/Diary.dart';
import '../../Util/Constrains.dart';
import '../../ViewModel/DiaryProvider.dart';
import '../../ViewModel/UIViewMode.dart';

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('일기 목록',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<DiaryProvider>(
        builder: (context, diaries, child) {
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: diaries.diaries.length,
            itemBuilder: (context, index) {
              final diary = diaries.diaries[index];
              return _buildDiaryCard(context, diary);
            },
          );
        },
      ),
    );
  }

  Widget _buildDiaryCard(BuildContext context, Diary diary) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Provider.of<UIViewModel>(context, listen: false).bigWelcome();
          Provider.of<DiaryProvider>(context, listen: false).selectDiary(diary);
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDiaryImage(diary),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      diary.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      diary.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    _buildDateRow(diary.date),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiaryImage(Diary diary) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: diary.imageURI.isNotEmpty
          ? Image.network(
        diary.imageURI[0],
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      )
          : Container(
        width: 80,
        height: 80,
        color: Colors.grey[300],
        child: Icon(Icons.photo, color: Colors.grey[500]),
      ),
    );
  }

  Widget _buildDateRow(DateTime date) {
    return Row(
      children: [
        Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
        SizedBox(width: 4),
        Text(
          DateFormat('yyyy년 MM월 dd일').format(date),
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }
}