import 'package:firebase_database/firebase_database.dart';

class AddPlacesToFirebaseDb {
  static final database = FirebaseDatabase.instance;

  static Stream<DatabaseEvent> getPlacesStream(String uid) {
    return database
        .ref()
        .child('users')
        .child(uid)
        .child('places')
        .onValue;
  }

  static Future<Map<String, dynamic>?> getPlaceDetails(String uid, String placeKey) async {
    DatabaseReference placeRef = database
        .ref()
        .child('users')
        .child(uid)
        .child('places')
        .child(placeKey);

    DataSnapshot dataSnapshot = (await placeRef.once()) as DataSnapshot;

    if (dataSnapshot.value != null) {
      return dataSnapshot.value as Map<String, dynamic>;
    } else {
      return null;
    }
  }


  static void deletePlace(String uid, String placeKey) {
    database
        .ref()
        .child('users')
        .child(uid)
        .child('places')
        .child(placeKey)
        .remove();
  }
}
