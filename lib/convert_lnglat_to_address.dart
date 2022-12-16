import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';

class CreateLatLongToAddress extends StatefulWidget {
  const CreateLatLongToAddress({super.key});

  @override
  State<CreateLatLongToAddress> createState() => _CreateLatLongToAddressState();
}

class _CreateLatLongToAddressState extends State<CreateLatLongToAddress> {
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
          GestureDetector(
            onTap: () async {
              final coordinates =
                  new Coordinates(24.923585987640987, 67.11612881703357);
              var address = await Geocoder.local
                  .findAddressesFromCoordinates(coordinates);
              var first = address.first;

              print("Address" +
                  first.featureName.toString() +
                  first.addressLine.toString());
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
