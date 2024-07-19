import 'package:flutter/material.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:intertravel/ViewModel/GeminiProvider.dart';
import 'package:provider/provider.dart';

class TravelSuggestionDialog extends StatefulWidget {
  const TravelSuggestionDialog({super.key});

  @override
  State<TravelSuggestionDialog> createState() => _TravelSuggestionDialogState();
}

class _TravelSuggestionDialogState extends State<TravelSuggestionDialog> {
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<GeminiProvider>(context, listen: false).travelSuggestions(
          Provider.of<DiaryProvider>(context, listen: false).diaries);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GeminiProvider>(builder: (context, geminiProvider, child) {
      return Container(
        height: 300,
        width: 300,
        child: ListView.builder(
          itemCount: geminiProvider.list.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(geminiProvider.list[index].location),
              subtitle: Text(geminiProvider.list[index].reason),
            );
          },
        ),
      );
    });
  }
}
