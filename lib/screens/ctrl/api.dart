import 'dart:convert';
import 'package:http/http.dart' as http;
String mainApi = 'https://dictnande.adventecho.com';

class API{

  Future<http.Response> getWords(lastime) {
    return http.get(
      Uri.parse('$mainApi/loadwords+lastime=$lastime'),
    ).timeout(Duration(seconds: 120));
  }

  // return mainApi
  String returnMainApi(){
    return mainApi;
  }
}