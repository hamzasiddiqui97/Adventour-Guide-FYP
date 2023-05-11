import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/model/vehicle.dart';
import 'package:google_maps_basics/pages/add_new_vehicle_page.dart';
import 'package:google_maps_basics/pages/vehicle_details_page.dart';

class TransportOwnerDashboardPage extends StatefulWidget {
  final String uid;
  List<Vehicle> vehicles = [];

  TransportOwnerDashboardPage({Key? key, required this.uid,}) : super(key: key);
  @override
  _TransportOwnerDashboardPageState createState() =>
      _TransportOwnerDashboardPageState();
}

class _TransportOwnerDashboardPageState
    extends State<TransportOwnerDashboardPage> {
  List<Vehicle> vehicles = [
    // Add your list of vehicles here
  ];
  String uid = FirebaseAuth.instance.currentUser!.uid;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: ColorPalette.secondaryColor,
        foregroundColor: ColorPalette.primaryColor,
        title: const Text('Transport Owner Dashboard'),
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
        backgroundColor: ColorPalette.secondaryColor,
        foregroundColor: ColorPalette.primaryColor,
        onPressed: () {
          // Navigate to the Add New Vehicle page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewVehiclePage(uid: uid)),
          );
        },
        tooltip: 'Add New Vehicle',
        child: const Icon(Icons.add),
      ),
    );
  }
}
