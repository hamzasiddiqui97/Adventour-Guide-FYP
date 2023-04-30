import 'package:firebase_database/firebase_database.dart';

class AddPlacesToFirebaseDb {
  static final database = FirebaseDatabase.instance;

  static Stream<DatabaseEvent> getPlacesStream(String uid, String tripName) {
    return database
        .ref()
        .child('users')
        .child(uid)
        .child('places')
        .child(tripName)
        .onValue;
  }

  // function to get trip names for MyPlan
  static Stream<DatabaseEvent> getTripsStream(String uid) {
    return database
        .ref()
        .child('users')
        .child(uid)
        .child('places')
        .onValue;
  }

  static Future<Map<String, dynamic>?> getPlaceDetails(String uid, String tripName, String placeKey) async {
    DatabaseReference placeRef = database
        .ref()
        .child('users')
        .child(uid)
        .child('places')
        .child(tripName)
        .child(placeKey);

    DatabaseEvent event = (await placeRef.once());
    DataSnapshot dataSnapshot = event.snapshot;

    if (dataSnapshot.value != null) {
      Map<String, dynamic> result = Map<String, dynamic>.from(dataSnapshot.value as Map);
      return result;
    } else {
      return null;
    }
  }

  static void deletePlace(String uid, String tripName, String placeKey) {
    database
        .ref()
        .child('users')
        .child(uid)
        .child('places')
        .child(tripName)
        .child(placeKey)
        .remove();
  }
}
