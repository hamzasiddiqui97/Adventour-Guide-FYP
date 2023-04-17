import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../core/constant/color_constants.dart';
import '../../../model/firebase_reference.dart';

class TripPlacesDetails extends StatefulWidget {
  final String uid;
  final String tripName;

  const TripPlacesDetails({Key? key, required this.uid, required this.tripName}) : super(key: key);

  @override
  State<TripPlacesDetails> createState() => _TripPlacesDetailsState();
}

class _TripPlacesDetailsState extends State<TripPlacesDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          
          backgroundColor: ColorPalette.secondaryColor,
          foregroundColor: ColorPalette.primaryColor,
          title: Text('${widget.tripName} Places'),
        ),
        body: StreamBuilder<DatabaseEvent>(
          stream: AddPlacesToFirebaseDb.getPlacesStream(widget.uid, widget.tripName),
          builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              Map<dynamic, dynamic> values = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              List<dynamic> places = values.values.toList();

              return ListView.builder(
                itemCount: places.length,
                itemBuilder: (BuildContext context, int index) {
                  String? placeKey = values.keys.elementAt(index) as String?;
                  if (placeKey == null) {
                    return const Center(child: Text('Invalid place data'));
                  }
                  return FutureBuilder<Map<String, dynamic>?>(
                    future: AddPlacesToFirebaseDb.getPlaceDetails(widget.uid, widget.tripName, placeKey),
                    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> placeDetailsSnapshot) {
                      if (placeDetailsSnapshot.hasData) {
                        Map<String, dynamic>? placeDetails = placeDetailsSnapshot.data;
                        String name = placeDetails?['name'] ?? 'Unknown';
                        String address = placeDetails?['address'] ?? 'No address';

                        return ListTile(
                          title: Text(name),
                          subtitle: Text(address),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
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
    );
  }
}
