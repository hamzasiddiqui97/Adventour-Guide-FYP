

import 'dart:convert';

DistanceWrapper? distanceWrapperFromJson(String str) => DistanceWrapper.fromJson(json.decode(str));

String distanceWrapperToJson(DistanceWrapper? data) => json.encode(data!.toJson());

class DistanceWrapper {
  DistanceWrapper({
    this.destinationAddresses,
    this.originAddresses,
    this.rows,
    this.status,
  });

  List<String?>? destinationAddresses;
  List<String?>? originAddresses;
  List<Rows?>? rows;
  String? status;

  factory DistanceWrapper.fromJson(Map<String, dynamic> json) => DistanceWrapper(
    destinationAddresses: json["destination_addresses"] == null ? [] : List<String?>.from(json["destination_addresses"]!.map((x) => x)),
    originAddresses: json["origin_addresses"] == null ? [] : List<String?>.from(json["origin_addresses"]!.map((x) => x)),
    rows: json["rows"] == null ? [] : List<Rows?>.from(json["rows"]!.map((x) => Rows.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "destination_addresses": destinationAddresses == null ? [] : List<dynamic>.from(destinationAddresses!.map((x) => x)),
    "origin_addresses": originAddresses == null ? [] : List<dynamic>.from(originAddresses!.map((x) => x)),
    "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x!.toJson())),
    "status": status,
  };
}

class Rows {
  Rows({
    this.elements,
  });

  List<Element?>? elements;

  factory Rows.fromJson(Map<String, dynamic> json) => Rows(
    elements: json["elements"] == null ? [] : List<Element?>.from(json["elements"]!.map((x) => Element.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "elements": elements == null ? [] : List<dynamic>.from(elements!.map((x) => x!.toJson())),
  };
}

class Element {
  Element({
    this.distance,
    this.duration,
    this.status,
  });

  Distance? distance;
  Distance? duration;
  String? status;

  factory Element.fromJson(Map<String, dynamic> json) => Element(
    distance: Distance.fromJson(json["distance"]),
    duration: Distance.fromJson(json["duration"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "distance": distance!.toJson(),
    "duration": duration!.toJson(),
    "status": status,
  };
}

class Distance {
  Distance({
    this.text,
    this.value,
  });

  String? text;
  int? value;

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
    text: json["text"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "value": value,
  };
}