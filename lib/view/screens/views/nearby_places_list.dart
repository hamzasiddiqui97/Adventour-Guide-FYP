import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_basics/.env.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/model/NearbyResponse.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'nearby_on_maps.dart';

class NearByPlacesScreen extends StatefulWidget {
  const NearByPlacesScreen({Key? key}) : super(key: key);

  @override
  State<NearByPlacesScreen> createState() => _NearByPlacesScreenState();
}

class _NearByPlacesScreenState extends State<NearByPlacesScreen> {
  String apiKey = googleApiKey;
  String radius = "5";
  List<String> placeType = ['All'];
  bool loading = false;

  double latitude = 24.86567779487795;
  double longitude = 67.02628335561303;

  List<String> placeTypes = [
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: MultiSelectBottomSheetField(

                            initialChildSize: 0.4,
                            maxChildSize: 0.7,
                            listType: MultiSelectListType.CHIP,
                            searchable: true,
                            buttonText: Text(placeType.isEmpty ? 'All' : placeType.join(', ')),
                            title: const Text("Area Type"),
                            selectedColor: ColorPalette.secondaryColor,
                            selectedItemsTextStyle: const TextStyle(color: Colors.white),

                            items: placeTypes.map((placeType) => MultiSelectItem<String>(placeType, placeType)).toList(),
                            onConfirm: (values) {
                              if (values.isEmpty) {
                                setState(() {
                                  placeType = ['All'];
                                });
                              } else {
                                setState(() {
                                  placeType = List<String>.from(values.cast<String>());
                                });
                              }
                            },

                            chipDisplay: MultiSelectChipDisplay(
                              onTap: (value) {
                                setState(() {
                                  placeType.remove(value);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          ColorPalette.secondaryColor)),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    await updateLocation();
                    await getNearbyPlaces();
                    setState(() {
                      loading = false;
                    });
                  },
                  child: const Text(
                    "Nearby Places",
                    style: TextStyle(
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                ),
                if (loading)
                  const Center(child: CircularProgressIndicator(color: ColorPalette.secondaryColor),),
                if (!loading && (nearbyPlacesResponse.results == null || nearbyPlacesResponse.results!.isEmpty))
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


  // storing responses in local storage for efficient api calls
  Future<void> setCache(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> getNearbyPlaces() async {
    if (radius == null ||
        radius.isEmpty ||
        double.tryParse(radius) == null ||
        double.parse(radius) <= 0) {
      showErrorDialog('Please enter a valid radius');
      return;
    }

    List<Results> allResults = [];

    // If the user selects 'All', set the placeType list to all available types
    if (placeType.contains('All')) {
      placeType = placeTypes;
    }

    // Fetch places for each type separately
    for (String type in placeType) {
      if (type == 'All') {
        continue;
      }

      String cacheKey = "cache_$latitude,$longitude,$radius,$type";
      String? cachedData = await getCache(cacheKey);
      print('pppppp ${placeType}');
      print('ppppppppp cache ${cachedData.toString()}');

      if (cachedData != null) {
        NearbyPlacesResponse currentTypeResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(cachedData));
        allResults.addAll(currentTypeResponse.results!);
      } else {
        var url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=$type&key=$apiKey');

        var response = await http.get(url);

        if (response.statusCode == 200) {
          NearbyPlacesResponse currentTypeResponse =
          NearbyPlacesResponse.fromJson(jsonDecode(response.body));
          allResults.addAll(currentTypeResponse.results!);

          // Cache the response
          await setCache(cacheKey, response.body);
        } else {
          showErrorDialog('Error fetching nearby places. Please try again later.');
          return;
        }
      }
    }

    setState(() {
      nearbyPlacesResponse.results = allResults;
    });
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
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
                  style: const TextStyle(
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
                    'Show on Map',
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
