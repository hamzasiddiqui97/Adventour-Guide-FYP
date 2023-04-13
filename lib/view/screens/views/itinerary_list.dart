import 'package:flutter/material.dart';
import '../../../core/constant/color_constants.dart';
import '../../../model/firebase_reference.dart';
import 'package:firebase_database/firebase_database.dart';


class ItineraryList extends StatefulWidget {
  final String uid;

  const ItineraryList({Key? key, required this.uid}) : super(key: key);

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
          stream: AddPlacesToFirebaseDb.getPlacesStream(widget.uid),
          builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              Map<dynamic, dynamic> values =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              List<dynamic> places = values.values.toList();
              return ListView.builder(
                itemCount: places.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder<Map<String, dynamic>>(
                    future: AddPlacesToFirebaseDb.getPlaceDetails(widget.uid, places[index]['key']),
                    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> placeDetailsSnapshot) {
                      if (placeDetailsSnapshot.hasData) {
                        Map<String, dynamic> placeDetails = placeDetailsSnapshot.data!;
                        return Card(
                          child: ListTile(
                            title: Text(placeDetails['name']),
                            subtitle: Text('${placeDetails['address']} \nDistance: ${placeDetails['distance']} \nTime: ${placeDetails['time']}'),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                AddPlacesToFirebaseDb.deletePlace(widget.uid, places[index]['key']);
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
