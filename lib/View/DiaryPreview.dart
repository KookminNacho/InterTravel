import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:provider/provider.dart';

import '../ViewModel/ImageProvider.dart';

class DiaryPreView extends StatefulWidget {
  const DiaryPreView({super.key});

  @override
  State<DiaryPreView> createState() => _DiaryPreViewState();
}

class _DiaryPreViewState extends State<DiaryPreView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Consumer<DiaryProvider>(builder: (context, diaries, child) {
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    diaries.diaries[index].imageURI.isNotEmpty
                        ? Image.memory(
                            Provider.of<ImageProviderModel>(context,
                                    listen: false)
                                .images[diaries.diaries[index].imageURI[0]]![1],
                            fit: BoxFit.contain,
                            width: 150,
                            height: 150,
                          )
                        : Container(
                            height: 150,
                            width: 150,
                            color: Colors.grey,
                          ),
                    Text(diaries.diaries[index].title),
                  ],
                ),
              );
            });
      }),
    );
  }
}
