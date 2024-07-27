import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:intertravel/ViewModel/GeminiProvider.dart';
import 'package:intertravel/theme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../Util/Constrains.dart';
import '../../ViewModel/UserData.dart';
import '../WelcomePage.dart';

class TravelSuggestionDialog extends StatefulWidget {
  const TravelSuggestionDialog({super.key});

  @override
  State<TravelSuggestionDialog> createState() => _TravelSuggestionDialogState();
}

class _TravelSuggestionDialogState extends State<TravelSuggestionDialog> {
  bool _alreadySuggested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final geminiProvider =
          Provider.of<GeminiProvider>(context, listen: false);
      final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
      final userData = Provider.of<UserData>(context, listen: false);

      geminiProvider.list.clear();
      if(userData.lastSuggestions.isEmpty) {
        await geminiProvider.travelSuggestions(diaryProvider.diaries, userData.tags);
        userData.lastSuggestions.add({geminiProvider.suggest: DateTime.now()});
      }
      else if (userData.lastSuggestions.last.values.last.day != DateTime.now().day) {
        _alreadySuggested = false;
        await geminiProvider.travelSuggestions(diaryProvider.diaries, userData.tags);
        userData.lastSuggestions.add({jsonEncode({"recommendation": geminiProvider.list}): DateTime.now()});
      } else {
        print(jsonDecode(userData.lastSuggestions.last.keys.last));
        jsonDecode(userData.lastSuggestions.last.keys.last)['recommendation']
            .forEach((element) {
          geminiProvider.addSuggest(Suggestions(
              location: element['region'], reason: element['reason']));
        });
        _alreadySuggested = true;
      }
      // geminiProvider.travelSuggestions(diaryProvider.diaries, userData.tags);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserData>(builder: (context, userData, child) {
      return Consumer<GeminiProvider>(
        builder: (context, geminiProvider, child) {
          return Column(
            children: [
              _buildTagButton(),
              Expanded(
                child: geminiProvider.list.isNotEmpty
                    ? _buildSuggestionList(geminiProvider)
                    : _buildLoadingIndicator(),
              ),
              (_alreadySuggested)
                  ? Text(
                      "AI 추천은 하루에 한 번씩 받을 수 있어요 \n"
                      "${formatDateHour(userData.lastSuggestions.last.values.last)}"
                      "에 마지막으로 추천받으셨어요.",
                      textAlign: TextAlign.center)
                  : Container(),
              MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("닫기")),
            ],
          );
        },
      );
    });
  }

  Widget _buildTagButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ElevatedButton.icon(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const TagListDialog(),
        ),
        icon: const Icon(Icons.tag),
        label: const Text("관심 태그 보기"),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: CustomTheme.light().primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSuggestionList(GeminiProvider geminiProvider) {
    return ListView.builder(
      itemCount: geminiProvider.list.length,
      itemBuilder: (context, index) {
        final suggestion = geminiProvider.list[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              suggestion.location,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                suggestion.reason,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            leading: Icon(
              Icons.place,
              color: CustomTheme.light().primaryColor,
              size: 30,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingAnimationWidget.waveDots(
          color: CustomTheme.light().highlightColor,
          size: 50,
        ),
        const SizedBox(height: 16),
        const Text(
          "여행 제안을 받아오는 중입니다.\n가끔 오류가 발생할 수 있어요!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
