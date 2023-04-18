import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../core/constant/color_constants.dart';
import '../../../model/firebase_reference.dart';
import '../views/myplan_trip_details.dart'; // Import the updated AddPlacesToFirebaseDb class

class MyPlan extends StatefulWidget {
  final String uid;

  const MyPlan({Key? key, required this.uid}) : super(key: key);

  @override
  State<MyPlan> createState() => _MyPlanState();
}

class _MyPlanState extends State<MyPlan> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: ColorPalette.secondaryColor,
          foregroundColor: ColorPalette.primaryColor,
          title: const Text('My Trips'),
          centerTitle: true,
        ),
        body: StreamBuilder<DatabaseEvent>(
          stream: AddPlacesToFirebaseDb.getTripsStream(widget.uid),
          builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              Map<dynamic, dynamic> values = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              List<String> tripNames = values.keys.cast<String>().toList();

              return ListView.builder(
                itemCount: tripNames.length,
                itemBuilder: (BuildContext context, int index) {
                  String tripName = tripNames[index];

                  return ExpansionTile(
                    title: Text(tripName),
                    children: [
                      ListTile(
                        title: Text('Show details for trip $tripName'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> TripPlacesDetails(uid: widget.uid, tripName: tripName)));
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              return const Center(child: Text('Nothing to Show'));
            }
          },
        ),
      ),
    );
  }
}
