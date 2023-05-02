import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/view/screens/pages/viewmapfortrip.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constant/color_constants.dart';
import '../../../distanceWrapper.dart';
import '../../../model/firebase_reference.dart';
import '../../../snackbar_utils.dart';

class TripPlacesDetails extends StatefulWidget {
  final String uid;
  final String tripName;

  const TripPlacesDetails({Key? key, required this.uid, required this.tripName})
      : super(key: key);

  @override
  State<TripPlacesDetails> createState() => _TripPlacesDetailsState();
}

class _TripPlacesDetailsState extends State<TripPlacesDetails> {

  Map<int, dynamic> tempPlaces = {};

  DistanceWrapper? distanceWrapper;
  TextStyle titleStyle =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  TextStyle titleSubHeadingStyle =
      const TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
  TextStyle subtitleStyle = const TextStyle(fontSize: 15);
  void shareGoogleMaps({double? latitude, double? longitude}) {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    Share.share(googleMapsUrl);
  }


  // Initialize variables here
  String name = 'No Details found';
  String address = 'No address found';
  String distance2 = 'No distance found';
  String time = 'No data found';
  double? lat = 0;
  double? long = 0;


  final List<LatLng> ListofLatLong = [];
  Dio dio = Dio();

  Future<DistanceWrapper?> distance({double? sourcelat, double? sourcelong, double? destinationlat, double? destinationlong}) async {
    final response = await dio.get(
      'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${sourcelat},${sourcelong}&origins=${destinationlat},${destinationlong}&key=AIzaSyCqIl--QAPbgr_cRpLTwtvDWjS31Dkgin4',
    );
     distanceWrapper = DistanceWrapper.fromJson(response.data);
    return distanceWrapper;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.secondaryColor,
          foregroundColor: ColorPalette.primaryColor,
          title: Text('${widget.tripName} Places'),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: AddPlacesToFirebaseDb.getPlacesStream(
                    widget.uid, widget.tripName),
                builder:
                    (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                        Map<dynamic, dynamic> values =
                            snapshot.data!.snapshot.value as Map<dynamic, dynamic>? ?? {};

                        // Filter out the fromDate and toDate keys
                        values.remove('fromDate');
                        values.remove('toDate');
                        // List<dynamic> places = values.values.toList();
                        print('Places data: $values'); // Add this line

                        // Sort places based on their sequence
                        // append data in temp list with sequence as key and all details as value
                        for (var entry in values.entries) {
                          int sequence = entry.value['sequence'] as int;
                          tempPlaces[sequence] = entry.value;
                        }
                        List<MapEntry<int, dynamic>> sortedEntries = tempPlaces.entries.toList();
                        sortedEntries.sort((a, b) => a.key.compareTo(b.key));
                        tempPlaces = Map<int, dynamic>.fromEntries(sortedEntries);
                        print('temp places keys${tempPlaces}');


                        LatLng? previousLocation;


                        return ListView.builder(
                      shrinkWrap: true,
                      // itemCount: places.length,
                          itemCount: tempPlaces.length,
                      itemBuilder: (BuildContext context, int index) {
                        String? placeKey = values.keys.elementAt(index) as String?;
                        if (placeKey == null) {
                          return const Center(child: Text('Invalid place data'));
                        }
                        return FutureBuilder<Map<String, dynamic>?>(
                          future: AddPlacesToFirebaseDb.getPlaceDetails(
                              widget.uid, widget.tripName, placeKey),
                          builder: (BuildContext context,
                              AsyncSnapshot<Map<String, dynamic>?>
                                  placeDetailsSnapshot) {

                            if (placeDetailsSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: SizedBox());
                            } else if (snapshot.hasError) {
                              return IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () {
                                  // Show the snackbar on error.
                                  Utils.showSnackBar(
                                      "Error occurred while fetching place details",
                                      false);
                                },
                              );
                            }

                            if (placeDetailsSnapshot.hasData) {
                              Map<String, dynamic>? placeDetails =
                                  placeDetailsSnapshot.data;

                              if (kDebugMode) {
                                print(
                                  'places details snapshot: ${placeDetailsSnapshot.data}');
                              }

                              // Update variables with new data
                              name = placeDetails?['name'] ?? 'No Details found';
                              address = placeDetails?['address'] ?? 'No address found';
                              distance2 = placeDetails?['distance'] ?? 'No distance found';
                              time = placeDetails?['time'] ?? 'No data found';
                              lat = placeDetails?['latitude'] ?? 0;
                              long = placeDetails?['longitude'] ?? 0;

                              if (lat != null && long != null) {
                                ListofLatLong.add(LatLng(lat ??0 , long??0));
                                if (index == 0) {
                                  previousLocation = LatLng(lat ?? 0, long?? 0);
                                } else {
                                  distance(
                                    sourcelat: previousLocation?.latitude,
                                    sourcelong: previousLocation?.longitude,
                                    destinationlat: lat,
                                    destinationlong: long,
                                  );
                                  previousLocation = LatLng(lat??0, long??0);
                                }
                              }

                              return Card(
                                margin: const EdgeInsets.all(16),
                                child: ListTile(
                                    title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: titleStyle,
                                          ),
                                          // Text(
                                          //   address,
                                          //   style: titleSubHeadingStyle,
                                          // ),
                                        ]),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Address: $address', style: subtitleStyle,),
                                        // Text(
                                        //   'Distance: ${distanceWrapper?.rows?[0]?.elements?[0]?.distance?.text.toString()} ',
                                        //   style: subtitleStyle,
                                        // ),
                                        // Text(
                                        //   'Time to reach: ${distanceWrapper?.rows?[0]?.elements?[0]?.duration?.text.toString()}',
                                        //   style: subtitleStyle,
                                        // ),
                                        Row(
                                          children: [
                                            ElevatedButton(onPressed: (){
                                              shareGoogleMaps(latitude: lat,longitude: long);
                                            }, child: const Text("Share Location",style: TextStyle(color: Colors.white),)),
                                          ],
                                        )
                                      ],
                                    )),
                              );
                            } else {
                              return const Center(child: SizedBox());
                            }
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No places for this trip'));
                  }
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  print(ListofLatLong.toString());
                  Get.to(ViewMapForTrip(list: ListofLatLong, tempPlaces: tempPlaces,));
                },
                child: const Text(
                  "View Map",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
