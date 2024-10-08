import 'package:firebase_database/firebase_database.dart' show DataSnapshot, FirebaseDatabase, DatabaseReference;
import 'package:google_maps_basics/model/vehicle.dart';

class VehicleService {
  final _dbRef = FirebaseDatabase.instance.reference();

  Future<List<VehicleModel>> getVehicles() async {
    final snapshot = await _dbRef.child('vehicles').get();
    final vehiclesData = (snapshot.value as Map<dynamic, dynamic>).cast<String, dynamic>();
    final vehicles = vehiclesData.entries.map((entry) {
      final id = entry.key;
      final data = Map<String, dynamic>.from(entry.value);
      return VehicleModel.fromMap(id, data);
    }).toList();
    return vehicles;
  }

  Future<VehicleModel> getVehicleById(String id) async {
    final snapshot = await _dbRef.child('vehicles').get();
    final data = (snapshot.value as Map<dynamic, dynamic>).cast<String, dynamic>();
    return VehicleModel.fromMap(id, data);
  }

  Future<void> addVehicle(VehicleModel vehicle) async {
    final newVehicleRef = _dbRef.child('vehicles').push();
    return newVehicleRef.set(vehicle.toMap());
  }

// Add any other methods you may need for your app
}
