// lib/models/vehicle.dart

class VehicleModel {
  final String name;
  final String id;
  final String description;
  final String ownerId;
  final String type;
  final String brand;
  final String model;
  final String year;
  final String rent;
  final String imageUrl;

  VehicleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.type,
    required this.brand,
    required this.model,
    required this.year,
    required this.rent,
    required this.imageUrl,
  });

  factory VehicleModel.fromMap(String id, Map<String, dynamic> data) {
    return VehicleModel(
      id: id,
      name: data['name'],
      description: data['description'],
      ownerId: data['ownerId'],
      type: data['type'],
      brand: data['brand'],
      model: data['model'],
      year: data['year'],
      rent: data['rent'].toString(),
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'ownerId': ownerId,
      'type': type,
      'brand': brand,
      'model': model,
      'year': year,
      'rent': rent,
      'imageUrl': imageUrl,
    };
  }
}
