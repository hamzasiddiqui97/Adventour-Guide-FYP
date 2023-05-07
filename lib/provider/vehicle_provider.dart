// lib/providers/vehicle_provider.dart

import 'package:flutter/foundation.dart';
import 'package:google_maps_basics/model/vehicle.dart';
import 'package:google_maps_basics/services/vehicle_service.dart';


class VehicleProvider extends ChangeNotifier {
  final VehicleService vehicleService;

  // Add this constructor
  VehicleProvider({required this.vehicleService});

  VehicleService _vehicleService = VehicleService();

  Future<List<Vehicle>> getVehicles() async {
    return await _vehicleService.getVehicles();
  }

  List<Vehicle> _vehicles = [
    // Add your vehicles here
  ];

  List<Vehicle> get vehicles {
    return [..._vehicles];
  }

// Add other methods for adding, updating, and deleting vehicles as needed
}
