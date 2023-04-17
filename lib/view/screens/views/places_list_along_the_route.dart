import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_basics/view/screens/views/itinerary_list.dart';
import 'package:google_maps_basics/view/screens/views/Places_detail_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constant/color_constants.dart';
import '../../../snackbar_utils.dart';

class PlacesListAlongTheRoute extends StatefulWidget {
  final List<Marker> markers;
  final List<Map<String, String>> distancesAndTimes;


  const PlacesListAlongTheRoute({Key? key, required this.markers, required this.distancesAndTimes})
      : super(key: key);

  @override
  _PlacesListAlongTheRouteState createState() =>
      _PlacesListAlongTheRouteState();
}

class _PlacesListAlongTheRouteState extends State<PlacesListAlongTheRoute> {
  late FirebaseAuth _auth;
  late User? currentUser;
  late String? userId;

  List<Map<String, dynamic>> _savedPlaces =
      []; // add list to store places locally


  bool _isTripNameSaved = false;


  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    currentUser = _auth.currentUser;
    userId = currentUser?.uid;
  }
  final TextEditingController _tripNameController = TextEditingController();


  // void _savePlaceToTrip(String name, String address, double lat, double lng, String distance, String time) {
  //   final placeData = {
  //     'name': name,
  //     'address': address,
  //     'latitude': lat,
  //     'longitude': lng,
  //     'distance': distance,
  //     'time': time,
  //   };
  //   setState(() {
  //     _savedPlaces.add(placeData);
  //   });
  //
  //   final FirebaseDatabase database = FirebaseDatabase.instance;
  //   DatabaseReference placesRef =
  //   database.ref().child("users").child(userId!).child("places").child(_tripNameController.text);
  //   try {
  //     placesRef.push().set(placeData);
  //     print("Place added ${placeData['name']}");
  //   } catch (error) {
  //     print("Failed to add place: $error");
  //   }
  // }

  Future<void> _saveTrip() async {
    // Check if the trip name is not empty
    if (_tripNameController.text.trim().isEmpty) {
      Utils.showSnackBar("Trip name cannot be empty", false);
      return;
    }

    setState(() {
      _isTripNameSaved = true;
    });

    final FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference placesRef =
    database.ref().child("users").child(userId!).child("places").child(_tripNameController.text);

    for (int i = 0; i < _savedPlaces.length; i++) {
      final placeData = _savedPlaces[i];
      try {
        await placesRef.push().set(placeData);
        print("Place added ${placeData['name']}");
      } catch (error) {
        print("Failed to add place: $error");
      }
    }

    setState(() {
      _savedPlaces = [];
    });

    Utils.showSnackBar("Places added successfully", true);
  }

  @override
  Widget build(BuildContext context) {
    print('Markers in PlacesListAlongTheRoute: ${widget.markers.length}');


    if (widget.markers.isEmpty) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: ColorPalette.secondaryColor,
              foregroundColor: ColorPalette.primaryColor,
              centerTitle: true,
              title: const Text('Places on Route')),
          body: const Center(child: Text('No points found')),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.secondaryColor,
          foregroundColor: ColorPalette.primaryColor,
          centerTitle: true,
          title: const Text('Places Along the Route'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tripNameController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Trip Name',
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 20,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      onChanged: (value) {
                        if (value.trim().isEmpty) {
                          Utils.showSnackBar("Trip name cannot be empty", false);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(ColorPalette.primaryColor),
                      backgroundColor: MaterialStateProperty.all(ColorPalette.secondaryColor),
                    ),
                    onPressed: () {
                      if (_tripNameController.text.trim().isNotEmpty) {
                        // Close the text field.
                        FocusScope.of(context).unfocus();
                        _saveTrip();
                      } else {
                        Utils.showSnackBar("Trip name cannot be empty", false);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
            if (_isTripNameSaved)
              Expanded(
              child: ListView.builder(
                itemCount: widget.distancesAndTimes.length, // Set itemCount to the minimum length of both lists
                itemBuilder: (context, index) {
                  final marker = widget.markers.elementAt(index);
                  final distanceAndTime = widget.distancesAndTimes[index];
                  print(distanceAndTime.entries.toString());
                  final distance = distanceAndTime['distance'] ?? 'Unknown';
                  final time = distanceAndTime['time'] ?? 'Unknown';

                  String distanceText;
                  if (index == 0) {
                    distanceText = '0 km (Starting point)';
                  } else {
                    distanceText = 'Distance from ${widget.markers[index - 1].infoWindow.title ?? 'Unknown'}: $distance';
                  }

                  return GestureDetector(
                      onTap: () {
                        final marker = widget.markers.elementAt(index);
                        final name = marker.infoWindow.title ?? 'Unknown';
                        final address = marker.infoWindow.snippet ??
                            'No vicinity information';
                        final imageUrl = '';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlacesDetail(
                              name: name,
                              address: address,
                              imageUrl: imageUrl,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                marker.infoWindow.title ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Text(
                              //   marker.infoWindow.snippet ??
                              //       'No vicinity information',
                              //   style: const TextStyle(
                              //     fontSize: 14,
                              //     color: Colors.grey,
                              //   ),
                              // ),
                              const SizedBox(height: 4),
                              Text(
                                distanceText,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),


                              // Text(
                              //   'Distance: $distance',
                              //   style: const TextStyle(
                              //     fontSize: 14,
                              //     color: Colors.grey,
                              //   ),
                              // ),
                              // const SizedBox(height: 4),
                              Text(
                                'Time: $time',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(ColorPalette.secondaryColor),
                                  foregroundColor: MaterialStateProperty.all<Color>(ColorPalette.primaryColor),
                                ),
                                onPressed: () {
                                  final name = marker.infoWindow.title ?? 'Unknown';
                                  final address = marker.infoWindow.snippet ?? 'No vicinity information';
                                  final imageUrl = '';
                                  final distance = distanceAndTime['distance'] ?? 'Unknown';
                                  final time = distanceAndTime['time'] ?? 'Unknown';

                                  setState(() {
                                    _savedPlaces.add({
                                      'name': name,
                                      'address': address,
                                      'latitude': marker.position.latitude,
                                      'longitude': marker.position.longitude,
                                      'distance': distance,
                                      'time': time,
                                    });
                                    print('on Pressed Add place to trip (_savedPlaceslength): ${_savedPlaces.length}');
                                  });

                                  Utils.showSnackBar("Place added to trip", true);
                                },
                                child: const Text('Add place to trip',
                                    style: TextStyle(
                                        color: ColorPalette.primaryColor)),
                              ),

                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.secondaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        if (_savedPlaces.isNotEmpty && _tripNameController.text.trim().isNotEmpty) {
                          final FirebaseDatabase database = FirebaseDatabase.instance;
                          DatabaseReference placesRef = database
                              .ref()
                              .child("users")
                              .child(userId!)
                              .child("places")
                              .child(_tripNameController.text);

                          for (int i = 0; i < _savedPlaces.length; i++) {
                            try {
                              await placesRef.push().set(_savedPlaces[i]);
                            } catch (error) {
                              print("Failed to add place: $error");
                              Utils.showSnackBar("Failed to add place", false);
                            }
                          }

                          setState(() {
                            _savedPlaces.clear();
                          });
                          Utils.showSnackBar("Places added successfully", true);
                        } else {
                          Utils.showSnackBar("No places saved or trip name is empty", false);
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ItineraryList(uid: userId?? 'default', tripName: _tripNameController.text)));
                      },
                      child: const Text(
                        'Save Trip',
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
