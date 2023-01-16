import 'dart:convert';
import 'package:google_maps_basics/model/article_model.dart';
import 'package:http/http.dart';


//Now let's make the HTTP request services
// this class will alows us to make a simple get http request
// from the API and get the Articles and then return a list of Articles
class ApiService {
  static const String sources = 'cnn';
  final endPointUrl = Uri.parse("https://newsapi.org/v2/top-headlines?sources=$sources&apiKey=30d8606feee9425a9ac3cb1b753caaea");
  //Now let's create the http request function
  // but first let's import the http package

  Future<List<Article>> getArticle() async {
    Response res = await get(endPointUrl);

    //first of all let's check that we got a 200 status code: this mean that the request was a success
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> body = json['articles'];

      //this line will allow us to get the different articles from the json file and putting them into a list
      List<Article> articles =
      body.map((dynamic item) => Article.fromJson(item)).toList();

      return articles;
    } else {
      throw ("Can't get the Articles");
    }
  }
}