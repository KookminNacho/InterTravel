import 'package:flutter/material.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:intertravel/ViewModel/GeminiProvider.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/UserData.dart';

class TravelSuggestionDialog extends StatefulWidget {
  const TravelSuggestionDialog({super.key});

  @override
  State<TravelSuggestionDialog> createState() => _TravelSuggestionDialogState();
}

class _TravelSuggestionDialogState extends State<TravelSuggestionDialog> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<GeminiProvider>(context, listen: false).travelSuggestions(
          Provider.of<DiaryProvider>(context, listen: false).diaries, Provider.of<UserData>(context, listen: false).tags);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GeminiProvider>(builder: (context, geminiProvider, child) {
      return Column(
        children: [
          Text("관심 태그: ${Provider.of<UserData>(context, listen: false).tags}"),
          Flexible(
            flex: 1,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView.builder(
                itemCount: geminiProvider.list.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(geminiProvider.list[index].location),
                    subtitle: Text(geminiProvider.list[index].reason),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
