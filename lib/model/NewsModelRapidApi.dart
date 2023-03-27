class RapidNewsModel {
  String? title;
  String? urlToImage;
  String? description;
  String? url;

  RapidNewsModel({this.title, this.urlToImage, this.description, this.url});

  factory RapidNewsModel.fromJson(Map<String, dynamic> json) {
    return RapidNewsModel(
      title: json['title'],
      urlToImage: json['urlToImage'],
      description: json['description'],
      url: json['url'],
    );
  }
}
