import 'package:flutter/material.dart';
import 'package:google_maps_basics/model/vehicle.dart';
import 'package:google_maps_basics/pages/vehicle_details_page.dart';
import 'package:google_maps_basics/pages/add_new_vehicle_page.dart';

class TransportOwnerDashboardPage extends StatefulWidget {
  List<Vehicle> vehicles = [];
  @override
  _TransportOwnerDashboardPageState createState() =>
      _TransportOwnerDashboardPageState();
}

class _TransportOwnerDashboardPageState
    extends State<TransportOwnerDashboardPage> {
  List<Vehicle> vehicles = [
    // Add your list of vehicles here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transport Owner Dashboard'),
      ),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(vehicles[index].imageUrl),
            ),
            title: Text(vehicles[index].name),
            subtitle: Text('Brand: ${vehicles[index].brand}'),
            onTap: () {
              // Navigate to VehicleDetailsPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VehicleDetailsPage(vehicle: vehicles[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add New Vehicle page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewVehiclePage()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Vehicle',
      ),
    );
  }
}
