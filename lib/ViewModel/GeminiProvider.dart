import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';

import '../Model/Diary.dart';

class GeminiProvider with ChangeNotifier {
  GenerativeModel? model;

  List<Suggestions> _suggestList = [];

  List<Suggestions> get list => _suggestList;

  String _response = '';

  String get response => _response;

  String _suggest = '';

  String get suggest => _suggest;

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

  void travelSuggestions(List<Diary> diaries) async {
    String TextLocation = '';
    suggest = '';

    for (Diary d in diaries) {
      TextLocation += "${d.location}${d.address} | ";
    }
    final prompt = [
      Content.text(
          "일기가 작성된 좌표와 주소는 $TextLocation입니다. 주소와 위치가 일치하지 않는 경우 위치를 우선으로 해주세요"
          "지금까지의 일기를 토대로 가볼만한 다음 여행지를 추천해주세요."
          "자료가 충분하지 않다면, 현재 가보지 않은 지역을 위주로 대중적인 여행지를 추천해주세요."
          "추천하는 지역과 관광지 이름 + 이유를 마치 API호출을 한 것처럼 Json 형식으로만 보내주세요, 그 외 텍스트는 반드시 없어야 합니다 아래는 예시입니다."
"""{"recommendation": [
{
"region": "관광지 이름",
"reason": "이유"
},]}""")
    ];
    print(TextLocation);

    try {
      final data = await model!.generateContent(prompt);
      String text = data.text!.replaceAll("```json", "");

      text = text.replaceAll("```", "");
      print(text);

      jsonDecode(text ?? '')['recommendation'].forEach((element) {
        print(element);
        addSuggest(Suggestions(
            location: element['region'],
            reason: element['reason']));
      });
    } catch (e) {
      print(e);
    }
  }

  void requestPrompt(List<Uint8List> image, Diary diary) async {
    final textPrompt = TextPart(
        "뒤에 나오는 내용은 일기와 일기의 사진입니다. 일기가 작성된 좌표와 주소는 ${diary.location}"
        " ${diary.address}입니다. 사진의 배경이 확실하다면 그 이름을, 확실하지 않아면 후보 여러 개를 말하고, 사진을 보고 떠오르는 키워드를 JSON 형식으로 출력해주세요.제목:${diary.title} 일기: ${diary.content}");

    final imagePrompt = [DataPart("image/jpeg", image[0])];

    Iterable<Part> data = [textPrompt];
    final prompt = [
      Content.multi(data),
    ];

    try {
      print('Generating content stream...');

      final data = model!.generateContentStream(prompt);

      await for (final chunk in data) {
        response += chunk.text ?? '';
      }
    } catch (e) {
      print(e);
    }
  }
}

class Suggestions {
  final String location;
  final String reason;

  Suggestions({required this.location, required this.reason}){
    print(location);
    print(reason);
  }
}
