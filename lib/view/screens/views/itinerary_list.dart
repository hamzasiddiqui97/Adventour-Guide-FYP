import 'package:flutter/material.dart';
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
          stream: AddPlacesToFirebaseDb.getPlacesStream(widget.uid,widget.tripName),
          builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              Map<dynamic, dynamic> values =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              List<dynamic> places = values.values.toList();
              print('Placesssss : ${places.toString()}');
              return ListView.builder(
                itemCount: places.length,
                itemBuilder: (BuildContext context, int index) {
                  String? placeKey = places[index]['key'] as String?;
                  if (placeKey == null) {
                    return const Center(child: Text('Invalid place data'));
                  }
                  return FutureBuilder<Map<String, dynamic>?>(
                    future: AddPlacesToFirebaseDb.getPlaceDetails(widget.uid, widget.tripName,placeKey),
                    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> placeDetailsSnapshot) {
                      if (placeDetailsSnapshot.hasData) {
                        Map<String, dynamic>? placeDetails = placeDetailsSnapshot.data;
                        String name = placeDetails?['name'] ?? 'Unknown';
                        String address = placeDetails?['address'] ?? 'No address';
                        String distance = placeDetails?['distance'] ?? 'Unknown';
                        String time = placeDetails?['time'] ?? 'Unknown';

                        return Card(
                          child: ListTile(
                            title: Text(name),
                            subtitle: Text('$address \nDistance: $distance \nTime: $time'),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                AddPlacesToFirebaseDb.deletePlace(widget.uid,widget.tripName, placeKey);
                              },
                            ),
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                },
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
