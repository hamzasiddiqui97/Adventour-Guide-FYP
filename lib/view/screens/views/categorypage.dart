// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:google_maps_basics/helper/categorydata.dart';
// import 'package:google_maps_basics/helper/newsdata.dart';
// import 'package:google_maps_basics/model/categorymodel.dart';
// import 'package:google_maps_basics/model/newsmodel.dart';
// import 'package:flutter/material.dart';
//
//
// class CategoryFragment extends StatefulWidget {
//
//   String category;
//   CategoryFragment({required this.category});
//   @override
//   _CategoryFragmentState createState() => _CategoryFragmentState();
// }
//
// class _CategoryFragmentState extends State<CategoryFragment> {
//
//
//   List<ArticleModel> articles = <ArticleModel>[];
//   bool _loading = true;
//
//   getNews() async {
//     CategoryNews newsdata = CategoryNews();
//     await newsdata.getNews(widget.category);
//     articles = newsdata.datatobesavedin;
//     setState(() { // important method otherwise you would have to perform hot relod always
//       _loading = false;
//     });
//
//
//   }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getNews();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue[900],
//         elevation: 0.0,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center, // this is to bring the row text in center
//           children: <Widget>[
//
//             Padding(
//               padding: const EdgeInsets.only(right:50),
//               child: Text(widget.category.toUpperCase(),
//                 style: const TextStyle(
//                     color: Colors.white
//                 ),
//               ),
//             ),
//
//
//
//           ],
//         ),
//       ),
//
//
//       // category widgets
//       body: _loading ? const Center(
//           child: CircularProgressIndicator()
//       ): SingleChildScrollView(
//
//         child: Container(
//           child: ListView.builder(
//             itemCount:  articles.length,
//             physics: const ClampingScrollPhysics(),
//             shrinkWrap: true, // add this otherwise an error
//             itemBuilder: (context, index) {
//
//               return NewsTemplate(
//                 urlToImage: articles[index].urlToImage,
//                 title: articles[index].title,
//                 description: articles[index].description,
//
//               );
//
//
//             } ,
//           ),
//         ),
//
//
//
//
//       ),
//
//     );
//
//   }
// }
//
//
//
// class NewsTemplate extends StatelessWidget {
//
//   String title, description, urlToImage;
//   NewsTemplate({super.key, required this.title, required this.description, required this.urlToImage});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       child: Column(
//
//         children: <Widget>[
//
//           ClipRRect(
//               borderRadius: BorderRadius.circular(6),
//               child: CachedNetworkImage(imageUrl: urlToImage, width: 380, height: 200, fit: BoxFit.cover,)),
//
//           const SizedBox(height: 8),
//
//           Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black),),
//
//           const SizedBox(height: 8),
//
//           Text(description, style: TextStyle( fontSize: 15.0, color: Colors.grey[800]),),
//
//
//
//
//
//         ],
//
//
//
//       ),
//     );
//   }
// }
