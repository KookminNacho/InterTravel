import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as HTTP;

class NaverGeoCoder {
  static const endPoint =
      'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?';
  static Map<String, String> params = {
    'output': 'json',
  };

  static Map<String, String> header = {
    'X-NCP-APIGW-API-KEY-ID': dotenv.env['ACCESS_KEY']!,
    "X-NCP-APIGW-API-KEY": dotenv.env['SECRET_KEY']!
  };

  static Future<String?> getCityName(NLatLng latLng) async {
    final uri = Uri.parse(endPoint +
        'coords=${latLng.longitude},${latLng.latitude}' +
        "&output=json&orders=roadaddr,admcode");
    HTTP.Response response = await HTTP.get(uri, headers: header);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final addType = data['results'][0]['name'];
      if(addType == "roadaddr") {
        String city = data['results'][0]['region']['area1']['name'] +
            " " +
            data['results'][0]['region']['area2']['name'] +
            " " +
            data['results'][0]['region']['area3']['name'] +
            " " +
            data['results'][0]['land']['name'];
        if(data['results'][0]['land']['addition0']["value"] != null){
          city += " " + data['results'][0]['land']['addition0']["value"];
        }
        return city;
      }

      String city = data['results'][0]['region']['area1']['name'] +
          " " +
          data['results'][0]['region']['area2']['name'] +
          " " +
          data['results'][0]['region']['area3']['name'] +
          " " +
          data['results'][0]['region']['area4']['name'];
      return city;
    }
    return null;
  }


}
