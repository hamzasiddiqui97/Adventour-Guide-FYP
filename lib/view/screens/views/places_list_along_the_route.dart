import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_basics/view/screens/pages/main_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../core/constant/color_constants.dart';
import '../../../snackbar_utils.dart';

class PlacesListAlongTheRoute extends StatefulWidget {
  final List<Marker> markers;
  final List<LatLng> polylineCoordinates;

  const PlacesListAlongTheRoute({Key? key,
    required this.markers,
    required this.polylineCoordinates})
      : super(key: key);

  @override
  _PlacesListAlongTheRouteState createState() =>
      _PlacesListAlongTheRouteState();
}

class _PlacesListAlongTheRouteState extends State<PlacesListAlongTheRoute> {
  late FirebaseAuth _auth;
  late User? currentUser;
  late String? userId;

  List<Map<String, dynamic>> _savedPlaces = []; // add list to store places locally

  bool _isTripNameSaved = false;

  // date picker
  DateTime? _fromDate;
  DateTime? _toDate;


  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    currentUser = _auth.currentUser;
    userId = currentUser?.uid;
  }

  final TextEditingController _tripNameController = TextEditingController();

  bool _isPlaceAdded(Marker marker) {
    return _savedPlaces.any((place) =>
    place['name'] == marker.infoWindow.title &&
        place['latitude'] == marker.position.latitude &&
        place['longitude'] == marker.position.longitude);
  }


  Map<String, dynamic> _addPlaceToTrip(Marker marker) {
    final name = marker.infoWindow.title ?? 'Unknown';
    final address = marker.infoWindow.snippet ?? 'No vicinity information';
    final imageUrl = '';
    final sequence = _savedPlaces.length + 1;

    return {
      'name': name,
      'address': address,
      'latitude': marker.position.latitude,
      'longitude': marker.position.longitude,
      'sequence': sequence, // Add sequence number
      'fromDate': _fromDate?.toIso8601String() ?? '',
      'toDate': _toDate?.toIso8601String() ?? '',
    };
  }


  Future<void> _saveTrip() async {
    // Check if the trip name is not empty and dates are selected
    if (_tripNameController.text.trim().isEmpty) {
      Utils.showSnackBar("Trip name cannot be empty", false);
      return;
    } else if (_fromDate == null || _toDate == null) {
      Utils.showSnackBar("Please select both From and To dates", false);
      return;
    }

    setState(() {
      _isTripNameSaved = true;
    });

    final FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference placesRef =
    database
        .ref()
        .child("users")
        .child('tourist')
        .child(userId!)
        .child("places")
        .child(_tripNameController.text);

    await placesRef.set({
      'fromDate': _fromDate!.toIso8601String(),
      'toDate': _toDate!.toIso8601String(),
    });

    // Save the places under the trip
    for (int i = 0; i < _savedPlaces.length; i++) {
      final placeData = _savedPlaces[i];
      try {
        await placesRef.push().set(placeData);
        print("Place added ${placeData['name']}");
      } catch (error) {
        print("Failed to add place: $error");
      }
    }
    print('savedPlaces: ${_savedPlaces.toString()}');

    setState(() {
      _savedPlaces = [];
    });

    print('original markers list: ${widget.markers}');
    Utils.showSnackBar("Places added successfully", true);
  }

  int _indexOfPlace(Marker marker) {
    return _savedPlaces.indexWhere((place) =>
    place['name'] == marker.infoWindow.title &&
        place['latitude'] == marker.position.latitude &&
        place['longitude'] == marker.position.longitude);
  }

  void _removePlaceFromTrip(int index) {
    setState(() {
      _savedPlaces.removeAt(index);
      for (int i = index; i < _savedPlaces.length; i++) {
        _savedPlaces[i]['sequence'] -= 1;
      }
    });
    Utils.showSnackBar("Place removed from trip", true);
  }

  @override
  Widget build(BuildContext context) {

    print('Markers in PlacesListAlongTheRoute: ${widget.markers.length}');


    if (widget.markers.isEmpty) {
      return Scaffold(
        appBar: AppBar(
            backgroundColor: ColorPalette.secondaryColor,
            foregroundColor: ColorPalette.primaryColor,
            centerTitle: true,
            title: const Text('Places on Route')),
        body: const Center(child: Text('No points found')),
      );
    }

    return Scaffold(
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

                const SizedBox(height: 8),
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _fromDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  _fromDate == null
                      ? 'Choose From Date'
                      : 'From: ${DateFormat('MM-dd-yyyy').format(_fromDate!)}',
                  style: const TextStyle(color: ColorPalette.secondaryColor),
                ),
              ),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _toDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  _toDate == null
                      ? 'Choose To Date'
                      : 'To: ${DateFormat('MM-dd-yyyy').format(_toDate!)}',
                  style: const TextStyle(color: ColorPalette.secondaryColor),
                ),
              ),
            ],
          ),

          if (_isTripNameSaved)
            Expanded(
            child: ListView.builder(
              itemCount: widget.markers.length,
              itemBuilder: (context, index) {
                final marker = widget.markers.elementAt(index);

                return GestureDetector(
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


                            const SizedBox(height: 8),



                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    ColorPalette.secondaryColor),
                                foregroundColor:
                                MaterialStateProperty.all<Color>(ColorPalette.primaryColor),
                              ),
                              onPressed: () {
                                int placeIndex = _indexOfPlace(marker);
                                if (placeIndex == -1) {
                                  final placeToAdd = _addPlaceToTrip(marker);
                                  setState(() {
                                    _savedPlaces.add(placeToAdd);
                                  });
                                  Utils.showSnackBar("Place added to trip", true);
                                } else {
                                  _removePlaceFromTrip(placeIndex);
                                }
                              },
                              child: Text(
                                _indexOfPlace(marker) == -1
                                    ? 'Add place to trip'
                                    : 'Remove place from trip',
                                style: const TextStyle(color: ColorPalette.primaryColor),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ));
              },
            ),
          ),
          if (_isTripNameSaved)

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
                    // Show confirmation dialog
                    bool result = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Save Trip'),
                          content: Text('Are you sure you want to save this trip?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: Text('Yes'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    ) ?? false;

                    if (result) {
                      List<Map<String, dynamic>> savedPlacesCopy = List.from(_savedPlaces);

                      if (_savedPlaces.isNotEmpty && _tripNameController.text.trim().isNotEmpty) {
                        final FirebaseDatabase database = FirebaseDatabase.instance;
                        DatabaseReference placesRef = database
                            .ref()
                            .child("users")
                            .child('tourist')
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
                      // Navigate to the next screen
                      Get.offAll(NavigationPage(uid: userId ?? '',));
                    }
                  },
                  child: const Text(
                    'Save Trip',
                  ),
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }
}
