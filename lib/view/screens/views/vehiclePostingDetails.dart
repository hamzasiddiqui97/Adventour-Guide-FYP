import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/snackbar_utils.dart';
import 'package:google_maps_basics/widgets/prompts.dart';

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
            Row(
              children: [
                InformationSection(
                  title: 'Description',
                  content: vehicle.description,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: (){
                      // print(property.uid);
                      if(vehicle.id==null){
                        Utils.showSnackBar("No UID", false);
                      }
                      else{
                        final uid = FirebaseAuth.instance.currentUser!.uid;

                        Prompts.bookNow(vehicle.id,true);
                        print(vehicle.id);
                        print(uid);

                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: 10,
                      ),
                      height: 40,
                      width: 120,
                      decoration: BoxDecoration(
                        color: ColorPalette.secondaryColor,
                        border: Border.all(color: ColorPalette.secondaryColor, width: 2),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            20,
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Book Now",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
        width: MediaQuery.of(context).size.width *0.6,
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
