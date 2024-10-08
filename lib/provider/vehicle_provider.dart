// lib/providers/vehicle_provider.dart

import 'package:flutter/foundation.dart';
import 'package:google_maps_basics/model/vehicle.dart';

import '../vehicleServices/vehicle_service.dart';


class VehicleProvider extends ChangeNotifier {
  final VehicleService vehicleService;

  // Add this constructor
  VehicleProvider({required this.vehicleService});

  VehicleService _vehicleService = VehicleService();

  Future<List<VehicleModel>> getVehicles() async {
    return await _vehicleService.getVehicles();
  }

  List<VehicleModel> _vehicles = [
    // Add your vehicles here
  ];

  List<VehicleModel> get vehicles {
    return [..._vehicles];
  }

// Add other methods for adding, updating, and deleting vehicles as needed
}
