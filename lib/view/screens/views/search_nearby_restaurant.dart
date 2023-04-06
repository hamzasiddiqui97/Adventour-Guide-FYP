import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_basics/.env.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/model/NearbyResponse.dart';
import 'package:http/http.dart' as http;
import 'nearby_on_maps.dart';

class NearbyRestaurantSource extends StatefulWidget {
  const NearbyRestaurantSource({Key? key}) : super(key: key);

  @override
  State<NearbyRestaurantSource> createState() => _NearbyRestaurantSourceState();
}

class _NearbyRestaurantSourceState extends State<NearbyRestaurantSource> {
  String apiKey = googleApiKey;
  String radius = "5";
  String placeType = 'restaurant';

  double latitude = 24.86567779487795;
  double longitude = 67.02628335561303;

  final placeTypes = [
    'restaurant',
    'cafe',
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
            'Nearby Restaurants',
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
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
                          .map((placeType) => DropdownMenuItem(
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
    return SafeArea(
      child: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: ColorPalette.secondaryColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (results.photos != null && results.photos!.isNotEmpty)
                SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: Image.network(
                    "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${results.photos![0].photoReference}&key=$googleApiKey",
                    fit: BoxFit.cover,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  results.name!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16,
                    ),
                    SizedBox(width: 5),
                    Text(
                      results.rating?.toString() ?? "Not Available",
                      style: TextStyle(
                        fontSize: 16,
                        color: results.rating != null
                            ? Colors.black
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Text(
                  results.vicinity ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Text(
                  results.openingHours != null ? "Open" : "Closed",
                  style: TextStyle(
                    fontSize: 16,
                    color: results.openingHours != null
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.secondaryColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapsViewScreen(
                          latitude: results.geometry!.location!.lat!,
                          longitude: results.geometry!.location!.lng!,
                          title: results.name!,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Navigate',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
