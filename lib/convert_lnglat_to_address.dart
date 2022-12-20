import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class CreateLatLongToAddress extends StatefulWidget {
  const CreateLatLongToAddress({super.key});

  @override
  State<CreateLatLongToAddress> createState() => _CreateLatLongToAddressState();
}

class _CreateLatLongToAddressState extends State<CreateLatLongToAddress> {
  String stAddress = '', stPlace = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(stAddress),
          Text(stPlace),
          GestureDetector(
            onTap: () async {
              // final coordinates = new Coordinates(24.923585987640987, 67.11612881703357);
              List<Location> locations =
                  await locationFromAddress("Gronausestraat 710, Enschede");

              List<Placemark> placemarks =
                  await placemarkFromCoordinates(52.2165157, 6.9437819);
              setState(() {
                stAddress = locations.last.longitude.toString();
                stPlace = placemarks.reversed.last.country.toString();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                height: 50,
                child: Center(
                  child: Text("Convert"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
