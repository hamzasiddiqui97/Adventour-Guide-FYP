// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:timeline_tile/timeline_tile.dart';
// import '../../../core/constant/color_constants.dart';
// import '../../../model/firebase_reference.dart';
// import 'package:firebase_database/firebase_database.dart';
// import '../pages/main_page.dart';
//
// class ItineraryList extends StatefulWidget {
//   final String uid;
//   final String tripName;
//   final List<Map<String, dynamic>> savedPlaces;
//   final List<Map<String, String>> distancesAndTimes;
//   final List<LatLng> polylineCoordinates;
//
//   ItineraryList(
//       {Key? key,
//       required this.uid,
//       required this.tripName,
//       required this.savedPlaces,
//         required this.distancesAndTimes, required this.polylineCoordinates})
//       : super(key: key);
//
//   @override
//   State<ItineraryList> createState() => _ItineraryListState();
// }
//
// class _ItineraryListState extends State<ItineraryList> {
//
//   @override
//   Widget build(BuildContext context) {
//     print('distancesAndTimes: ${widget.distancesAndTimes}'); // Add this line to print the values
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: ColorPalette.secondaryColor,
//           foregroundColor: ColorPalette.primaryColor,
//           title: const Text('Selected Places'),
//           centerTitle: true,
//         ),
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: ColorPalette.secondaryColor,
//           foregroundColor: ColorPalette.primaryColor,
//           onPressed: () {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => NavigationPage(uid: widget.uid),
//               ),
//               (route) => false,
//             );
//           },
//           child: const Icon(Icons.done),
//         ),
//         body: StreamBuilder<DatabaseEvent>(
//           stream: AddPlacesToFirebaseDb.getPlacesStream(
//               widget.uid, widget.tripName),
//           builder:
//               (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
//             if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
//               print('Snapshot data: ${snapshot.data!.snapshot.value}');
//
//               Map<dynamic, dynamic> values =
//                   snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//
//               // Filter out the unwanted keys
//               Map<dynamic, dynamic> filteredValues = Map.fromEntries(
//                   values.entries.where((entry) =>
//                       entry.key != 'fromDate' && entry.key != 'toDate'));
//
//               List<dynamic> places = filteredValues.values.toList();
//
//               print('Placesssss : ${places.toString()}');
//               return RefreshIndicator(
//                 onRefresh: () async {
//                   setState(() {});
//                 },
//                 child: ListView.builder(
//                   itemCount: places.length,
//                   // itemCount: widget.savedPlaces.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     String? placeKey =
//                         filteredValues.keys.elementAt(index) as String?;
//                     if (placeKey == null) {
//                       return const Center(child: Text('Invalid place data'));
//                     }
//
//                     return FutureBuilder<Map<String, dynamic>?>(
//                       future: AddPlacesToFirebaseDb.getPlaceDetails(
//                           widget.uid, widget.tripName, placeKey),
//                       builder: (BuildContext context,
//                           AsyncSnapshot<Map<String, dynamic>?>
//                               placeDetailsSnapshot) {
//                         if (placeDetailsSnapshot.hasData) {
//
//                           Map<String, dynamic>? placeDetails =
//                               placeDetailsSnapshot.data;
//                           String name = placeDetails?['name'] ?? 'Unknown';
//                           String address =
//                               placeDetails?['address'] ?? 'No address';
//                           // String distance =
//                           //     placeDetails?['distance'] ?? 'Unknown';
//                           // String time = placeDetails?['time'] ?? 'Unknown';
//
//                           String? distance = index < widget.distancesAndTimes.length
//                               ? widget.distancesAndTimes[index]['distance']
//                               : 'Unknown';
//
//                           String? time = index < widget.distancesAndTimes.length
//                               ? widget.distancesAndTimes[index]['time']
//                               : 'Unknown';
//
//                           DateTime fromDate =
//                               DateTime.parse(values["fromDate"]);
//                           DateTime toDate = DateTime.parse(values["toDate"]);
//
//                           String formattedFromDate =
//                               "${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}";
//                           String formattedToDate =
//                               "${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}";
//
//                           return TimelineTile(
//                             alignment: TimelineAlign.manual,
//                             lineXY:
//                                 0.15, // You can adjust this value to change the line position
//                             indicatorStyle: const IndicatorStyle(
//                               width: 20,
//                               color: ColorPalette.secondaryColor,
//                               indicatorXY: 0.4, // Match lineXY value
//                             ),
//                             beforeLineStyle: const LineStyle(
//                               color: ColorPalette.secondaryColor,
//                               thickness: 4,
//                             ),
//                             afterLineStyle: const LineStyle(
//                               color: ColorPalette.secondaryColor,
//                               thickness: 4,
//                             ),
//                             startChild: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Start: $formattedFromDate'),
//                               ],
//                             ),
//                             endChild: Card(
//                               child: ListTile(
//                                 title: Text(name),
//                                 subtitle: Text(
//                                     '$address \nDistance: $distance \nTime: $time'),
//                                 isThreeLine: true,
//                                 trailing: IconButton(
//                                   icon: const Icon(Icons.delete),
//                                   onPressed: () {
//                                     AddPlacesToFirebaseDb.deletePlace(
//                                         widget.uid, widget.tripName, placeKey);
//                                   },
//                                 ),
//                               ),
//                             ),
//                           );
//                         } else {
//                           print('No data in the snapshot or no places');
//
//                           return const Center(
//                               child: CircularProgressIndicator());
//                         }
//                       },
//                     );
//                   },
//                 ),
//               );
//             } else {
//               return const Center(
//                 child: Text('No places saved'),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:math' show atan2, cos, pi, sin, sqrt;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../../core/constant/color_constants.dart';
import '../../../model/firebase_reference.dart';
import 'package:firebase_database/firebase_database.dart';
import '../pages/main_page.dart';

class ItineraryList extends StatefulWidget {
  final String uid;
  final String tripName;
  final List<Map<String, dynamic>> savedPlaces;
  final List<Map<String, String>> distancesAndTimes;
  final List<LatLng> polylineCoordinates;

  ItineraryList(
      {Key? key,
      required this.uid,
      required this.tripName,
      required this.savedPlaces,
      required this.distancesAndTimes,
      required this.polylineCoordinates})
      : super(key: key);

  @override
  State<ItineraryList> createState() => _ItineraryListState();
}

class _ItineraryListState extends State<ItineraryList> {


  late List<double> distances;
  @override
  void initState() {
    super.initState();
    distances = calculateDistances(widget.polylineCoordinates,widget.savedPlaces);
  }

  double calculateDistanceBetweenTwoPoints(LatLng start, LatLng end) {
    const double earthRadius = 6371; // Earth radius in kilometers

    double latDistance = (end.latitude - start.latitude) * pi / 180;
    double lonDistance = (end.longitude - start.longitude) * pi / 180;

    double a = sin(latDistance / 2) * sin(latDistance / 2) +
        cos(start.latitude * pi / 180) *
            cos(end.latitude * pi / 180) *
            sin(lonDistance / 2) *
            sin(lonDistance / 2);

    num c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  int getSegmentIndex(List<LatLng> polylineCoordinates, LatLng point) {
    double minDistance = double.infinity;
    int index = 0;

    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      double distance = calculateDistanceBetweenTwoPoints(polylineCoordinates[i], point);

      if (distance < minDistance) {
        minDistance = distance;
        index = i;
      }
    }

    return index;
  }

  List<double> calculateDistances(List<LatLng> coordinates, List<Map<String, dynamic>> savedPlaces) {
    List<double> distances = [];

    for (int i = 0; i < savedPlaces.length - 1; i++) {
      LatLng start = LatLng(savedPlaces[i]['latitude'], savedPlaces[i]['longitude']);
      LatLng end = LatLng(savedPlaces[i + 1]['latitude'], savedPlaces[i + 1]['longitude']);

      int startIndex = getSegmentIndex(coordinates, start);
      int endIndex = getSegmentIndex(coordinates, end);

      double currentDistance = 0;
      for (int j = startIndex; j < endIndex; j++) {
        currentDistance += calculateDistanceBetweenTwoPoints(coordinates[j], coordinates[j + 1]);
      }

      distances.add(currentDistance);
    }

    return distances;
  }



  @override
  Widget build(BuildContext context) {


    print('Selected points: ${widget.savedPlaces}');
    for (int i = 0; i < widget.savedPlaces.length; i++) {
      String name = widget.savedPlaces[i]['name'];
      if (i == 0) {
        print('$i. $name (Source)');
      } else if (i - 1 < distances.length) {
        String previousName = widget.savedPlaces[i - 1]['name'];
        print('$i. $name (distance from $previousName: ${distances[i - 1].toStringAsFixed(2)} km)');
      }
    }


    print('distancesAndTimes: ${widget.distancesAndTimes}');

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorPalette.secondaryColor,
          foregroundColor: ColorPalette.primaryColor,
          title: const Text('Selected Places'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorPalette.secondaryColor,
          foregroundColor: ColorPalette.primaryColor,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationPage(uid: widget.uid),
              ),
              (route) => false,
            );
          },
          child: const Icon(Icons.done),
        ),
        body: StreamBuilder<DatabaseEvent>(
          stream: AddPlacesToFirebaseDb.getPlacesStream(
              widget.uid, widget.tripName),
          builder:
              (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              print('Snapshot data: ${snapshot.data!.snapshot.value}');

              Map<dynamic, dynamic> values =
                  snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

              Map<dynamic, dynamic> filteredValues = Map.fromEntries(
                  values.entries.where((entry) =>
                      entry.key != 'fromDate' && entry.key != 'toDate'));

              List<dynamic> places = filteredValues.values.toList();

              print('Placesssss : ${places.toString()}');
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (BuildContext context, int index) {
                    String? placeKey =
                        filteredValues.keys.elementAt(index) as String?;
                    if (placeKey == null) {
                      return const Center(child: Text('Invalid place data'));
                    }

                    return FutureBuilder<Map<String, dynamic>?>(
                      future: AddPlacesToFirebaseDb.getPlaceDetails(
                          widget.uid, widget.tripName, placeKey),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>?>
                              placeDetailsSnapshot) {
                        if (placeDetailsSnapshot.hasData) {
                          Map<String, dynamic>? placeDetails =
                              placeDetailsSnapshot.data;
                          String name = placeDetails?['name'] ?? 'Unknown';
                          String address =
                              placeDetails?['address'] ?? 'No address';

                          String distance = '';
                          if (index == 0) {
                            distance = '0 km (Source)';
                          } else if (index - 1 < distances.length) {
                            String startPointName = widget.savedPlaces[index - 1]['name'] ?? 'Unknown';
                            String endPointName = widget.savedPlaces[index]['name'] ?? 'Unknown';
                            distance = distances[index - 1].toStringAsFixed(2) + ' km (from ' + startPointName + ' to ' + endPointName + ')';
                          }



                          DateTime fromDate =
                              DateTime.parse(values["fromDate"]);
                          DateTime toDate = DateTime.parse(values["toDate"]);

                          String formattedFromDate =
                              "${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}";
                          String formattedToDate =
                              "${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}";

                          return TimelineTile(
                            alignment: TimelineAlign.manual,
                            lineXY: 0.15,
                            indicatorStyle: const IndicatorStyle(
                              width: 20,
                              color: ColorPalette.secondaryColor,
                              indicatorXY: 0.4,
                            ),
                            beforeLineStyle: const LineStyle(
                              color: ColorPalette.secondaryColor,
                              thickness: 4,
                            ),
                            afterLineStyle: const LineStyle(
                              color: ColorPalette.secondaryColor,
                              thickness: 4,
                            ),
                            startChild: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Start: $formattedFromDate'),
                              ],
                            ),
                            endChild: Card(
                              child: ListTile(
                                title: Text(name),
                                subtitle:
                                    Text('$address \nDistance: $distance'),
                                isThreeLine: true,
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    AddPlacesToFirebaseDb.deletePlace(
                                        widget.uid, widget.tripName, placeKey);
                                  },
                                ),
                              ),
                            ),
                          );
                        } else {
                          print('No data in the snapshot or no places');

                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text('No places saved'),
              );
            }
          },
        ),
      ),
    );
  }
}
