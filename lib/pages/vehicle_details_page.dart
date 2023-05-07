import 'package:flutter/material.dart';
import 'package:google_maps_basics/model/vehicle.dart';

class VehicleDetailsPage extends StatelessWidget {
  final Vehicle? vehicle;

  VehicleDetailsPage({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle?.name ?? 'Vehicle Details'),
      ),
      body: vehicle == null
          ? Center(child: Text('No vehicle data available'))
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(vehicle!.imageUrl), // Add this line to display the image
            SizedBox(height: 16), // Add some spacing between the image and the text
            Text('Name: ${vehicle!.name}',
                style: Theme.of(context).textTheme.headline6),
            Text('Description: ${vehicle!.description}'),
            Text('Type: ${vehicle!.type}'),
            Text('Brand: ${vehicle!.brand}'),
            Text('Model: ${vehicle!.model}'),
            Text('Year: ${vehicle!.year}'),
            Text('Rent: ${vehicle!.rent}'),
          ],
        ),
      ),
    );
  }
}
