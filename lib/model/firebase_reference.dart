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
