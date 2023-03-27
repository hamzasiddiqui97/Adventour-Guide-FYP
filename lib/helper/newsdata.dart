import 'dart:convert';
import 'package:google_maps_basics/model/newsmodel.dart';
import 'package:http/http.dart' as http;

class News {

  // save json data inside this
  List<NewsModel> datatobesavedin = [];

  Future<void> getNews() async {

    var news = Uri.parse('https://newsapi.org/v2/everything?q=tourism&apiKey=30d8606feee9425a9ac3cb1b753caaea');
    var response = await http.get(news);
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage']!=null && element['description']!=null) {
          // initliaze our model class
          NewsModel articleModel = NewsModel(
            title: element['title'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            url: element['url'],
          );
          datatobesavedin.add(articleModel);
        }
      });
    }
  }
}
