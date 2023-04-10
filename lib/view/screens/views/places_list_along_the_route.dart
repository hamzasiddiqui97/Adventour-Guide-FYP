import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_basics/view/screens/views/itinerary_list.dart';
import 'package:google_maps_basics/view/screens/views/Places_detail_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constant/color_constants.dart';
import '../../../snackbar_utils.dart';

class PlacesListAlongTheRoute extends StatefulWidget {
  final List<Marker> markers;

  const PlacesListAlongTheRoute({Key? key, required this.markers})
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

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    currentUser = _auth.currentUser;
    userId = currentUser?.uid;
  }

  void _savePlaceToTrip(String name, String address, double lat, double lng) {
    setState(() {
      final newPlace = {
        'name': name,
        'address': address,
        'latitude': lat,
        'longitude': lng,
      };
      _savedPlaces.add(newPlace);
    });
  }

  Future<void> _saveTrip() async {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference placesRef =
        database.ref().child("users").child(userId!).child("places");

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
            Expanded(
              child: ListView.builder(
                itemCount: widget.markers.length,
                itemBuilder: (context, index) {
                  final marker = widget.markers.elementAt(index);
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
                              Text(
                                marker.infoWindow.snippet ??
                                    'No vicinity information',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          ColorPalette.secondaryColor),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          ColorPalette.primaryColor),
                                ),
                                onPressed: () {
                                  final name =
                                      marker.infoWindow.title ?? 'Unknown';
                                  final address = marker.infoWindow.snippet ??
                                      'No vicinity information';
                                  final imageUrl = '';
                                  setState(() {
                                    _savedPlaces.add({
                                      'name': name,
                                      'address': address,
                                      'latitude': marker.position.latitude,
                                      'longitude': marker.position.longitude,
                                    });
                                    print('on Pressed Add place to trip (_savedPlaceslength): ${_savedPlaces.length}');
                                  });
                                  Utils.showSnackBar(
                                      "Place added to trip", true);
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
                        if (_savedPlaces.isNotEmpty) {
                          final FirebaseDatabase database =
                              FirebaseDatabase.instance;
                          DatabaseReference placesRef = database
                              .ref()
                              .child("users")
                              .child(userId!)
                              .child("places");

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
                          Utils.showSnackBar("No places saved", false);
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ItineraryList(uid: userId?? 'default')));
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
