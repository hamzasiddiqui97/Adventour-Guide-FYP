class NewsModel {
  String? title;
  String? description;
  String? urlToImage;
  String? url;

  NewsModel({
    this.title,
    this.description,
    this.urlToImage,
    this.url,
  });

  factory NewsModel.fromRapidApiJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'],
      urlToImage: json['urlToImage'],
      description: json['description'],
      url: json['url'],
    );
  }

  factory NewsModel.fromNewsApiJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'],
      urlToImage: json['urlToImage'],
      description: json['description'],
      url: json['url'],
    );
  }
}
