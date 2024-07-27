import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:intertravel/Repository/UserRepository.dart';
import 'package:intertravel/View/DIalog/TravelSuggestionDialog.dart';
import 'package:provider/provider.dart';

import '../Model/Diary.dart';
import 'UserData.dart';

class GeminiProvider with ChangeNotifier {
  void initializeTags() {
    selectedBackgrounds = List.generate(tags.background.length, (_) => false);
    selectedKeywords = List.generate(tags.keywords.length, (_) => false);
    notifyListeners();
  }

  List<bool> selectedBackgrounds = [];
  List<bool> selectedKeywords = [];

  Tags _tags = Tags(background: [], keywords: []);

  Tags get tags => _tags;

  GenerativeModel? model;

  final List<Suggestions> _suggestList = [];

  List<Suggestions> get list => _suggestList;

  String _response = '';

  String get response => _response;

  String _suggest = '';

  String get suggest => _suggest;

  set tags(Tags value) {
    _tags = value;
    notifyListeners();
  }

  set response(String value) {
    _response = value;
    notifyListeners();
  }

  set suggest(String value) {
    _suggest = value;
    notifyListeners();
  }

  void addSuggest(Suggestions value) {
    _suggestList.add(value);
    notifyListeners();
  }

  Future<void> init() async {
    try {
      model =
          FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');
    } catch (e) {
      print(e);
    }
  }

  Future<void> travelSuggestions(List<Diary> diaries, List<String> tags) async {
    String TextLocation = '';
    suggest = '';

    for (Diary d in diaries) {
      TextLocation += "${d.location}${d.address} | ";
    }
    final prompt = [
      Content.text(
          "일기가 작성된 좌표와 주소는 $TextLocation입니다."""
          "주소와 위치가 일치하지 않는 경우 위치를 우선으로 해주세요"
          "여행자가 추가한 여행 관련 태그는 ${tags}입니다"
          "지금까지의 자료를 토대로 기존에 가보지 않은 맞는 새로운 여행지를 추천해주세요."
          "자료가 충분하지 않다면, 대중적이고 가능하다면 중복되지 않는 여행지를 추천해주세요."
          "태그 중 관광지 이름의 태그는 이미 가본 관광지일 확률이 높습니다. 이를 고려하여 추천해주세요."
          "데이터의 우선순위는 제목, 위치, 주소, 태그입니다. 기존 여행과 중복되는 여행지가 있어서는 안됩니다."
          "체험활동 둘, 이색 관광지 둘, 대표 관광지 둘, 이렇게 총 6개 추천해주세요."
          "태그의 순서는 고려하지 않습니다. 같은 우선순위로 간주합니다."
          "추천하는 지역명이 아니라 관광지 이름 + 이유를 마치 API호출을 한 것처럼 Json 형식으로만 보내주세요, 그 외 텍스트는 반드시 없어야 합니다 아래는 예시입니다."
          """
          {"recommendation": [
            {
              "region": "관광지 이름",
              "reason": "이유"
            },
          ]}""")
    ];

    try {
      final data = await model!.generateContent(prompt);
      String text = data.text!.replaceAll("```json", "");
      print(text);

      text = text.replaceAll("```", "");
      suggest = text;
      jsonDecode(text ?? '')['recommendation'].forEach((element) {
        addSuggest(Suggestions(
            location: element['region'], reason: element['reason']));
      });
      UserRepository userRepository = UserRepository();
      userRepository.updateSuggestions([{text: DateTime.now()}]);
    } catch (e) {
      print("ERROR in travelSuggestions: $e");
    }
  }

  void requestPrompt(List<Uint8List> image, Diary diary) async {
    final textPrompt = TextPart(
        "뒤에 나오는 내용은 일기와 일기의 사진입니다. 일기가 작성된 좌표와 주소는 ${diary.location}"
        " ${diary.address}입니다. 사진의 배경이 확실하다면 그 이름을, 확실하지 않아면 후보 여러 개를 말하고, 사진을 보고 떠오르는 키워드를 JSON 형식으로 출력해주세요.제목:${diary.title} 일기: ${diary.content}"
        """ json 예시: {"backgrounds": [], "keywords": []}""");

    final imagePrompt = DataPart("image/jpeg", image[0]);

    final prompt = [
      Content.multi([textPrompt, imagePrompt]),
    ];

    try {
      final data = await model!.generateContent(prompt);
      String text = data.text!.replaceAll("```json", "").replaceAll("```", "");
      response = text;
      var jsonData = jsonDecode(text);

      // 'backgrounds'와 'keywords'를 직접 접근
      List<String> backgrounds = List<String>.from(jsonData['backgrounds']);
      List<String> keywords = List<String>.from(jsonData['keywords']);

      tags = Tags(background: backgrounds, keywords: keywords);
      initializeTags();
    } catch (e) {
      print("Error in requestPrompt: $e");
    }
  }
}

class Suggestions {
  final String location;
  final String reason;

  Suggestions({required this.location, required this.reason});

}

class Tags {
  final List<String> background;
  final List<String> keywords;

  Tags({required this.background, required this.keywords});
}
