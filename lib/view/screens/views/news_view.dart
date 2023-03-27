
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/helper/newsdata.dart';
import 'package:google_maps_basics/model/newsmodel.dart';
import '../../../helper/newsdata_from_rapidApi.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<NewsModel> articles = <NewsModel>[];
  List<NewsModel> rapidNews = <NewsModel>[];
  bool _loading = true;

  getNews() async {
    News newsdata = News();
    await newsdata.getNews();
    setState(() {
      articles = newsdata.datatobesavedin;
      _loading = false;
    });
  }

  getRapidNews() async {
    RapidNews rapidNewsdata = RapidNews();
    await rapidNewsdata.getRapidNews();
    setState(() {
      rapidNews = rapidNewsdata.rapidNews.cast<NewsModel>();
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getNews();
    getRapidNews();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> mergedList = [];
    mergedList.addAll(articles);
    mergedList.addAll(rapidNews);
    mergedList.shuffle();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'News',
          ),
          centerTitle: true,
          foregroundColor: ColorPalette.primaryColor,
          backgroundColor: ColorPalette.secondaryColor,
        ),
        body: _loading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  child: ListView.builder(
                    itemCount: mergedList.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (mergedList[index] is NewsModel) {
                        return NewsTemplate(
                          urlToImage: mergedList[index].urlToImage,
                          title: mergedList[index].title,
                          description: mergedList[index].description,
                        );
                      } else {
                        return RapidNewsTemplate(
                          urlToImage: mergedList[index].urlToImage,
                          title: mergedList[index].title,
                          description: mergedList[index].description,
                          url: mergedList[index].url,
                        );
                      }
                    },
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
class RapidNewsTemplate extends StatelessWidget {
  String title, description, urlToImage, url;
  RapidNewsTemplate({
  required this.title,
    required this.description,
    required this.urlToImage,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // launch(url);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(urlToImage),
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14.0),
            ),
          ],
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