import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_basics/.env.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/model/NearbyResponse.dart';
import 'package:google_maps_basics/view/screens/pages/maps_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;


class NearByPlacesScreen extends StatefulWidget {
  const NearByPlacesScreen({Key? key}) : super(key: key);

  @override
  State<NearByPlacesScreen> createState() => _NearByPlacesScreenState();
}

class _NearByPlacesScreenState extends State<NearByPlacesScreen> {

  String apiKey = googleApiKey;
  String radius = "5";
  String placeType = 'All';

  double latitude = 24.86567779487795;
  double longitude = 67.02628335561303;

  final placeTypes = [
    'All',
    'tourist_attraction',
    'gas_station',
    'restaurant',
    'cafe',
    'hospital',
    'police',
    'atm',
    'parking',
    'bank',
    'car_rental',
    'embassy'
  ];

  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  @override
  void initState() {
    super.initState();
    updateLocation();
  }


  void setRadius(String newRadius) {
    setState(() {
      radius = newRadius;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: ColorPalette.primaryColor,
          backgroundColor: ColorPalette.secondaryColor,
          title: const Text(
            'Nearby Places',
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [

                const SizedBox(height: 10,),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 1.5,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Radius",
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: ColorPalette.secondaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      prefixIcon:
                      Icon(Icons.radar, color: ColorPalette.secondaryColor),
                      hintText: "Enter radius",
                      contentPadding: EdgeInsets.all(20),
                    ),
                    onChanged: (newRadius) => setRadius(newRadius),
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    expands: false,

                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    const Text('Area Type:'),
                    DropdownButton(
                      hint: Text(placeType == '' ? 'All' : placeType),
                      items: placeTypes
                          .map((placeType) =>
                          DropdownMenuItem(
                            value: placeType == 'All' ? '' : placeType,
                            child: Text(placeType),
                          ))
                          .toList(),
                      onChanged: (String? newPlaceType) {
                        setState(() => placeType = newPlaceType!);
                      },
                      enableFeedback: true,
                      menuMaxHeight: 250.0,
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          ColorPalette.secondaryColor)),
                  onPressed: () {
                    updateLocation();
                    getNearbyPlaces();
                  },
                  child: const Text(
                    "Nearby Places",
                    style: TextStyle(
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                ),
                if (nearbyPlacesResponse.results == null ||
                    nearbyPlacesResponse.results!.isEmpty)
                  const Center(child: Text("No results found")),
                if (nearbyPlacesResponse.results != null)
                  for (int i = 0; i < nearbyPlacesResponse.results!.length; i++)
                    nearbyPlacesWidget(nearbyPlacesResponse.results![i]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // if radius value is negative this will show up on screen
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(ColorPalette.secondaryColor)),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: ColorPalette.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void getNearbyPlaces() async {
    if (radius == null ||
        radius.isEmpty ||
        double.tryParse(radius) == null ||
        double.parse(radius) <= 0) {
      showErrorDialog('Please enter a valid radius');
      return;
    }

    // for specific area type       &type=gas_station
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=$placeType&key=$apiKey');

    var response = await http.post(url);

    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    setState(() {});
  }


  Future<void> updateLocation() async {
    // First, request permission to access the user's location
    await Geolocator.requestPermission();
    // Then, get the current position
    final position = await Geolocator.getCurrentPosition();

    // Update the latitude and longitude variables with the values from the position object
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  Widget nearbyPlacesWidget(Results results) {
    return Center(
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: ColorPalette.secondaryColor),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${results.name!}"),
            // Text("Location: ${results.geometry!.location!.lat} , ${results.geometry!.location!.lng}"),
            Text("Rating: ${results.rating ?? "Not Available"}"),
            Text(
                """Place Status: ${results.openingHours != null
                    ? "Open"
                    : "Closed"}"""),
            Center(
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          ColorPalette.secondaryColor)),
                  onPressed: () {
                    setState(() {
                      log('llllllll ${results.geometry?.location?.lat}');
                      log('nnnn ${results.geometry?.location?.lng}');

                      // Navigator.()(context, '/onBoardingScreen');

                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HomePageGoogleMaps(
                          lat: results.geometry?.location?.lat,
                          long: results.geometry?.location?.lng,)
                      ));

                      // latitude = results.geometry!.location!.lat!;
                      // longitude = results.geometry!.location!.lng!;
                    });
                  },
                  child: const Text('Navigate')),
            ),
          ],
        ),
      ),
    );
  }
}