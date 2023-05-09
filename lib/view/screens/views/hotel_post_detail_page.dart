import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/hotelOwnerController.dart';
import '../../../controllers/mainController.dart';
import '../../../core/constant/color_constants.dart';
import '../../../models/PropertyModel.dart';
class HotelPostDetailsPage extends StatelessWidget {
  final Property property;

  const HotelPostDetailsPage({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String?> images = [
      property.coverImage,
      property.file1,
      property.file2,
      property.file3,
      property.file4,
      property.file5,
      property.file6,
    ].where((img) => img != null && img.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.secondaryColor,
        foregroundColor: ColorPalette.primaryColor,
        title: const Text('Hotel Post Details'),
        centerTitle: true,
      ),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: List.generate(images.length, (index) {
                    return Image.network(images[index]!, fit: BoxFit.cover);
                  }),
                ),
              ),
              Text('Title: ${property.title}', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Description: ${property.description}'),
              Text('Bedroom: ${property.bedroom}'),
              Text('Washroom: ${property.washroom}'),
              Text('Car Parking: ${property.carParking}'),
              Text('Kitchen: ${property.kitchen}'),
              Text('Floor Area: ${property.floorArea}'),
              Text('Tap Available: ${property.tapAvailable}'),
              Text('Air Conditioner: ${property.airConditioner}'),
              Text('Quarter Available: ${property.quarterAvailable}'),
              Text('Price: ${property.price}'),
              Text('Street Name: ${property.streetName}'),
              Text('Full Address: ${property.fullAddress}'),
            ],
          ),
        ),
      ),
    );
  }
}
