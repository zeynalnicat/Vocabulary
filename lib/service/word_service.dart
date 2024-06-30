
import 'dart:convert';

import '../model/Word.dart';
import 'package:http/http.dart' as http;

const String url = "https://api.dictionaryapi.dev/api/v2/entries/en/";

class WordService{


  Future<Word?> fetchData(String word) async {
    final response = await http.get(Uri.parse("$url$word"));

    if(response.statusCode==200){
      final List<dynamic> data = json.decode(response.body);
      return Word.fromJson(data[0]);
    }

    else{
      return null ;
    }
  }
}