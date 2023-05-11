class RequestModel {
  String? uid;
  String? date;

  RequestModel({required this.uid, required this.date});

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      uid: map['uid'],
      date: map['date'],
    );
  }
}
