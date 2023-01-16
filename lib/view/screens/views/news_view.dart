import 'package:flutter/material.dart';
import 'package:google_maps_basics/api_service/news_api.dart';
import 'package:google_maps_basics/core/widgets/custom_list_tile.dart';
import 'package:google_maps_basics/model/article_model.dart';


class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  ApiService client = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),

      //Now let's call the APi services with futurebuilder wiget
      body: FutureBuilder(
        future: client.getArticle(),
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          //let's check if we got a response or not
          if (snapshot.hasData) {
            //Now let's make a list of articles
            List<Article>? articles = snapshot.data;
            if(articles!.isNotEmpty){
              return ListView.builder(
                //Now let's create our custom List tile
                itemCount: articles!.length,
                itemBuilder: (context, index) =>
                    customListTile(articles[index], context),
              );
            }else{
              return const Center(child: Center(child: Text("Nothing to show")));
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
