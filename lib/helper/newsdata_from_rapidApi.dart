
import 'dart:convert';

import '../model/NewsModelRapidApi.dart';
import 'package:http/http.dart' as http;
class RapidNews {
  List<RapidNewsModel> rapidNews = [];

  static const Map<String, String> headers = {
    'X-RapidAPI-Key': '5843457f22msh1543769225b1348p154628jsn77fe1eb72d25',
    'X-RapidAPI-Host': 'newsdata2.p.rapidapi.com',
  };
  Future<List<RapidNewsModel>> getRapidNews() async {
    final Uri uri = Uri.https('newsdata2.p.rapidapi.com', '/news', {
      'country': 'pk',
      'language': 'en',
      'q': 'tourism',
      'category': 'tourism',
    });

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      if (data['articles'] == null) return []; // Add a null check
      final List<dynamic> articles = data['articles'];
      rapidNews = articles.map((article) => RapidNewsModel.fromJson(article)).toList();
      return rapidNews;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }


}
