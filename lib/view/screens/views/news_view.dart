import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/helper/newsdata.dart';
import 'package:google_maps_basics/model/newsmodel.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // TextEditingController _searchController = TextEditingController();


  // get our categories list
  // List<CategoryModel> categories = <CategoryModel>[];

  // get our newslist first

  List<ArticleModel> articles = <ArticleModel>[];
  bool _loading = true;

  getNews() async {
    News newsdata = News();
    await newsdata.getNews();
    articles = newsdata.datatobesavedin;
    setState(() {
      _loading = false;
    });
  }



  @override
  void initState() {
    super.initState();
    // categories = getCategories();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('News'),
        centerTitle: true,
        foregroundColor: ColorPalette.primaryColor,
        backgroundColor: ColorPalette.secondaryColor,),
        body: _loading ? const Center(
          child: CircularProgressIndicator(
          ),

        ): SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
              //   TextField(
              // controller: _searchController,
              // decoration: InputDecoration(
              //   hintText: "Search news by destination",
              //   border: InputBorder.none,
              //   suffixIcon: IconButton(
              //     icon: Icon(Icons.search),
              //     onPressed: () {
              //       getNews(_searchController.text);
              //     },
              //   ),
              // ),
              //   ),
                Container(
                  child: ListView.builder(
                    itemCount:  articles.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true, // add this otherwise an error
                    itemBuilder: (context, index) {

                      return NewsTemplate(
                        urlToImage: articles[index].urlToImage,
                        title: articles[index].title,
                        description: articles[index].description,
                      );
                    } ,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class NewsTemplate extends StatelessWidget {

  String title, description, urlToImage;
  NewsTemplate({required this.title, required this.description, required this.urlToImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(imageUrl: urlToImage, width: 380, height: 200, fit: BoxFit.cover,)),

          const SizedBox(height: 8),

          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black),),

          const SizedBox(height: 8),

          Text(description, style: TextStyle( fontSize: 15.0, color: Colors.grey[800]),),

        ],
      ),
    );
  }
}