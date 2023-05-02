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


  Future<String?> _showEditTripDialog(BuildContext context, String initialTripName) async {
    TextEditingController _tripNameController = TextEditingController(text: initialTripName);

    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Trip Name'),
          content: TextField(
            controller: _tripNameController,
            decoration: const InputDecoration(
              labelText: 'Trip Name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                String newTripName = _tripNameController.text.trim();
                if (newTripName.isNotEmpty && newTripName != initialTripName) {
                  Navigator.of(context).pop(newTripName);
                }
              },
            ),
          ],
        );
      },
    );
  }

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
          builder:
              (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              Map<dynamic, dynamic> values =
                  snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              List<String> tripNames = values.keys.cast<String>().toList();

              return ListView.builder(
                itemCount: tripNames.length,
                itemBuilder: (BuildContext context, int index) {
                  String tripName = tripNames[index];

                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripPlacesDetails(
                              uid: widget.uid,
                              tripName: tripName,
                            ),
                          ),
                        );
                      },
                      onLongPress: () async {
                        String? newTripName = await _showEditTripDialog(context, tripName);
                        if (newTripName != null && newTripName.isNotEmpty) {
                          // Update trip name in the database
                          await AddPlacesToFirebaseDb.updateTripName(widget.uid, tripName, newTripName);
                          setState(() {}); // Refresh the UI after updating the trip name
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tripName,
                              style: const TextStyle(fontSize: 16),
                            ),
                            PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: const [
                                      Icon(Icons.edit, color: ColorPalette.secondaryColor),
                                      SizedBox(width: 8),
                                      Text('Edit Trip Name'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: const [
                                      Icon(Icons.delete, color: ColorPalette.secondaryColor,),
                                      SizedBox(width: 8),
                                      Text('Delete Trip'),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) async {
                                switch (value) {
                                  case 'edit':
                                    String? newTripName = await _showEditTripDialog(context, tripName);
                                    if (newTripName != null && newTripName.isNotEmpty) {
                                      // Update trip name in the database
                                      await AddPlacesToFirebaseDb.updateTripName(widget.uid, tripName, newTripName);
                                      setState(() {}); // Refresh the UI after updating the trip name
                                    }
                                    break;
                                  case 'delete':
                                    bool? shouldDelete = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: const Text('Are you sure you want to delete this trip?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Delete'),
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (shouldDelete == true) {
                                      await AddPlacesToFirebaseDb.removeTrip(widget.uid, tripName);
                                      setState(() {}); // To refresh the UI after deletion
                                    }
                                    break;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
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
