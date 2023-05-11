import 'package:flutter/material.dart';
import 'package:google_maps_basics/model/vehicle.dart';
import 'package:google_maps_basics/provider/vehicle_provider.dart';
import 'package:provider/provider.dart';

class VehicleListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vehicleData = Provider.of<VehicleProvider>(context);
    final List<VehicleModel> vehicles = vehicleData.vehicles;

    return Scaffold(
      appBar: AppBar(title: Text('Vehicle List')),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (ctx, i) => ListTile(
          title: Text('${vehicles[i].brand} ${vehicles[i].model}'),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/vehicle_details',
              arguments: vehicles[i].id,
            );
          },
        ),
      ),
    );
  }
}
