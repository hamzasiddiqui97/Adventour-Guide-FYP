import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/core/widgets/prompts.dart';
import 'package:google_maps_basics/snackbar_utils.dart';
import '../../../models/PropertyModel.dart';
import '../../../core/constant/color_constants.dart';
import 'package:google_maps_basics/view/screens/views/pictures_details.dart';

class HotelPostDetailsTouristPage extends StatelessWidget {
  final Property property;

  const HotelPostDetailsTouristPage({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: [
            // Image Section
            GestureDetector(
              onTap: () {
                List<String> images = [
                  property.file1,
                  property.file2,
                  property.file3,
                  property.file4,
                  property.file5,
                  property.file6,
                ].where((image) => image != null && image.isNotEmpty).toList();
                Get.to(() => PhotosDetailsPage(images: images));
              },
              child: Container(
                height: 200,
                child: PageView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      images[index]!,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            // Title and Price
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
                            property.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        Column(
                          children: [
                            Text(
                              'PKR ${property.price}',
                              style: const TextStyle(
                                fontSize: 32,
                                color: ColorPalette.secondaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: (){
                                  // print(property.uid);
                                  if(property.uid==null){
                                    Utils.showSnackBar("No UID", false);
                                  }
                                  else{
                                  Prompts.bookNow(property.uid!);}
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    right: 10,
                                  ),
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: ColorPalette.secondaryColor,
                                    border: Border.all(color: Colors.black, width: 2),
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
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
              content: property.description,
            ),
            // Hotel Details Section
            InformationSection(

              title: 'Details',
              content: 'Bedroom: ${property.bedroom}\n'
                  'Car Parking: ${property.carParking}\n'
                  'Kitchen: ${property.kitchen}\n'
                  'Floor Area: ${property.floorArea}\n'
                  'Water Availability: ${property.tapAvailable}\n'
                  'Air Conditioner: ${property.airConditioner}\n'
                  'Quarter Available: ${property.quarterAvailable}',
            ),
            // Location Section
            InformationSection(
              title: 'Location',
              content: 'Street Name: ${property.streetName}\n'
                  'Full Address: ${property.fullAddress}',
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
