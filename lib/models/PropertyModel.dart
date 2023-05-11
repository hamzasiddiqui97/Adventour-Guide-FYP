
class Property {
  String? uid;
  String title;
  String description;
  String bedroom;
  String washroom;
  String carParking;
  String kitchen;
  int floorArea;
  String tapAvailable;
  String airConditioner;
  String quarterAvailable;
  int price;
  String? coverImage;
  String file1;
  String file2;
  String file3;
  String file4;
  String file5;
  String file6;
  String streetName;
  String fullAddress;

  Property({
    required this.title,
     this.uid,
    required this.description,
    required this.bedroom,
    required this.washroom,
    required this.carParking,
    required this.kitchen,
    required this.floorArea,
    required this.tapAvailable,
    required this.airConditioner,
    required this.quarterAvailable,
    required this.price,
    required this.coverImage,
    required this.file1,
    required this.file2,
    required this.file3,
    required this.file4,
    required this.file5,
    required this.file6,
    required this.streetName,
    required this.fullAddress,
  });

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      uid: map['uid'],
      title: map['title'] as String,
      description: map['description'] as String,
      bedroom: map['bedroom'] as String,
      washroom: map['washroom'] as String,
      carParking: map['carParking'] as String,
      kitchen: map['kitchen'] as String,
      floorArea: map['floorArea'] as int,
      tapAvailable: map['tapAvailable'] as String,
      airConditioner: map['airConditioner'] as String,
      quarterAvailable: map['quarterAvailable'] as String,
      price: map['price'] as int,
      coverImage: map['coverImage'] as String?,
      file1: map['file1'] as String,
      file2: map['file2'] as String,
      file3: map['file3'] as String,
      file4: map['file4'] as String,
      file5: map['file5'] as String,
      file6: map['file6'] as String,
      streetName: map['streetName'] as String,
      fullAddress: map['fullAddress'] as String,
    );
  }
}
