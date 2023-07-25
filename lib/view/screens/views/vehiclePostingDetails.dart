import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';

import '../../../model/vehicle.dart';

class VehiclePostDetails extends StatelessWidget {
  final VehicleModel vehicle;

  const VehiclePostDetails({
    Key? key,
    required this.vehicle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorPalette.primaryColor,
        backgroundColor: ColorPalette.secondaryColor,
        title: const Text('Vehicle Post Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: [
            // Image Section
            Container(
              height: 200,
              child: Image.network(
                vehicle.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Title and Rent
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            vehicle.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          'PKR ${vehicle.rent}',
                          style: const TextStyle(
                            fontSize: 32,
                            color: ColorPalette.secondaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            // Description Section
            InformationSection(
              title: 'Description',
              content: vehicle.description,
            ),
            // Vehicle Details Section
            InformationSection(
              title: 'Details',
              content: 'Type: ${vehicle.type}\n'
                  'Brand: ${vehicle.brand}\n'
                  'Model: ${vehicle.model}\n'
                  'Year: ${vehicle.year}\n'
                  // 'Rent: \$${vehicle.rent}',
            ),
          ],
        ),
      ),
    );
  }
}

class InformationSection extends StatelessWidget {
  final String title;
  final String content;

  InformationSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
