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

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    currentUser = _auth.currentUser;
    userId = currentUser?.uid;
  }

  Future<void> addPlaceToTrip(
      String name, String address, double lat, double lng) async {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference placesRef =
        database.ref().child("users").child(userId!).child("places");

    Map<String, dynamic> placeData = {
      'name': name,
      'address': address,
      'latitude': lat,
      'longitude': lng,
    };

    try {
      await placesRef.push().set(placeData);
      print("Place added $name");
      Utils.showSnackBar("Place added successfully", true);
    } catch (error) {
      print("Failed to add place: $error");
      Utils.showSnackBar("Failed to add place", false);
    }
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
              title: const Text('Points'),
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
                                    addPlaceToTrip(
                                        marker.infoWindow.title ?? 'Unknown',
                                        marker.infoWindow.snippet ??
                                            'No vicinity information',
                                        marker.position.latitude,
                                        marker.position.longitude);
                                  },
                                  child: const Text('Add place to trip',
                                      style: TextStyle(
                                          color: ColorPalette.primaryColor)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
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
                            onPressed: () {
                              if (userId != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ItineraryList(uid: userId!)));
                              } else {
                                Utils.showSnackBar("User not found", false);
                              }
                            },
                            child: const Text(
                              'Itinerary List',
                            )),
                      ),
                    ))
              ],
            ),
        ),
    );
  }
}
