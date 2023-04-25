// import 'package:flutter/material.dart';
// import '../../../core/constant/color_constants.dart';
// import '../../../model/firebase_reference.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class ItineraryList extends StatefulWidget {
//   final String uid;
//   final String tripName;
//
//   const ItineraryList({Key? key, required this.uid, required this.tripName}) : super(key: key);
//
//   @override
//   State<ItineraryList> createState() => _ItineraryListState();
// }
//
// class _ItineraryListState extends State<ItineraryList> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: ColorPalette.secondaryColor,
//           foregroundColor: ColorPalette.primaryColor,
//           title: const Text('Selected Places'),
//           centerTitle: true,
//         ),
//         body: StreamBuilder<DatabaseEvent>(
//           stream: AddPlacesToFirebaseDb.getPlacesStream(widget.uid, widget.tripName),
//           builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
//             if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
//               print('Snapshot data: ${snapshot.data!.snapshot.value}');
//
//               Map<dynamic, dynamic> values =
//               snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//
//               // Filter out the unwanted keys
//               Map<dynamic, dynamic> filteredValues = Map.fromEntries(
//                   values.entries.where((entry) => entry.key != 'fromDate' && entry.key != 'toDate'));
//
//               List<dynamic> places = filteredValues.values.toList();
//               print('Placesssss : ${places.toString()}');
//               return RefreshIndicator(
//                 onRefresh: () async {
//                   setState(() {});
//                 },
//                 child: ListView.builder(
//                   itemCount: places.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     String? placeKey = values.keys.elementAt(index) as String?;
//                     if (placeKey == null) {
//                       return const Center(child: Text('Invalid place data'));
//                     }
//                     return FutureBuilder<Map<String, dynamic>?>(
//                       future: AddPlacesToFirebaseDb.getPlaceDetails(widget.uid, widget.tripName, placeKey),
//                       builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> placeDetailsSnapshot) {
//                         if (placeDetailsSnapshot.hasData) {
//                           Map<String, dynamic>? placeDetails = placeDetailsSnapshot.data;
//                           String name = placeDetails?['name'] ?? 'Unknown';
//                           String address = placeDetails?['address'] ?? 'No address';
//                           String distance = placeDetails?['distance'] ?? 'Unknown';
//                           String time = placeDetails?['time'] ?? 'Unknown';
//
//
//                           return Card(
//                             child: ListTile(
//                               title: Text(name),
//                               subtitle: Text('$address \nDistance: $distance \nTime: $time'),
//                               isThreeLine: true,
//                               trailing: IconButton(
//                                 icon: const Icon(Icons.delete),
//                                 onPressed: () {
//                                   AddPlacesToFirebaseDb.deletePlace(widget.uid, widget.tripName, placeKey);
//                                 },
//                               ),
//                             ),
//                           );
//                         } else {
//                           print('No data in the snapshot or no places');
//
//                           return const Center(child: CircularProgressIndicator());
//                         }
//                       },
//                     );
//                   },
//                 ),
//               );
//
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




import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../../core/constant/color_constants.dart';
import '../../../model/firebase_reference.dart';
import 'package:firebase_database/firebase_database.dart';

class ItineraryList extends StatefulWidget {
  final String uid;
  final String tripName;

  const ItineraryList({Key? key, required this.uid, required this.tripName}) : super(key: key);

  @override
  State<ItineraryList> createState() => _ItineraryListState();
}

class _ItineraryListState extends State<ItineraryList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorPalette.secondaryColor,
          foregroundColor: ColorPalette.primaryColor,
          title: const Text('Selected Places'),
          centerTitle: true,
        ),
        body: StreamBuilder<DatabaseEvent>(
          stream: AddPlacesToFirebaseDb.getPlacesStream(
              widget.uid, widget.tripName),
          builder: (BuildContext context,
              AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              print('Snapshot data: ${snapshot.data!.snapshot.value}');

              Map<dynamic, dynamic> values =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

              // Filter out the unwanted keys
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
                    String? placeKey = filteredValues.keys.elementAt(
                        index) as String?;
                    if (placeKey == null) {
                      return const Center(child: Text('Invalid place data'));
                    }

                    return FutureBuilder<Map<String, dynamic>?>(
                      future: AddPlacesToFirebaseDb.getPlaceDetails(
                          widget.uid, widget.tripName, placeKey),
                      builder: (BuildContext context, AsyncSnapshot<
                          Map<String, dynamic>?> placeDetailsSnapshot) {
                        if (placeDetailsSnapshot.hasData) {
                          Map<String,
                              dynamic>? placeDetails = placeDetailsSnapshot
                              .data;
                          String name = placeDetails?['name'] ?? 'Unknown';
                          String address = placeDetails?['address'] ??
                              'No address';
                          String distance = placeDetails?['distance'] ??
                              'Unknown';
                          String time = placeDetails?['time'] ?? 'Unknown';

                          DateTime fromDate = DateTime.parse(values["fromDate"]);
                          DateTime toDate = DateTime.parse(values["toDate"]);

                          String formattedFromDate = "${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}";
                          String formattedToDate = "${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}";

                          return TimelineTile(
                            alignment: TimelineAlign.manual,
                            lineXY: 0.15, // You can adjust this value to change the line position
                            indicatorStyle: const IndicatorStyle(
                              width: 20,
                              color: ColorPalette.secondaryColor,
                              indicatorXY: 0.4, // Match lineXY value
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
                                subtitle: Text(
                                    '$address \nDistance: $distance \nTime: $time'),
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
