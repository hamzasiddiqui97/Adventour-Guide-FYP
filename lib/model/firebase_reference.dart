import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class AddPlacesToFirebaseDb {
  static final database = FirebaseDatabase.instance;


  void saveUserCredentials(String uid, String email, String password) {
    database
        .ref()
        .child('users')
        .child('tourist')
        .child(uid)
        .child('credential')
        .set({'email': email, 'password' :password})
        .catchError((error) {
      if (kDebugMode) {
        print('Error saving user credentials: $error');
      }
    });
  }


  static Stream<DatabaseEvent> getPlacesStream(String uid, String tripName) {
    return database
        .ref()
        .child('users')
        .child('tourist')
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
        .child('tourist')
        .child(uid)
        .child('places')
        .onValue;
  }

  static Future<Map<String, dynamic>?> getPlaceDetails(
      String uid, String tripName, String placeKey) async {
    DatabaseReference placeRef = database
        .ref()
        .child('users')
        .child('tourist')
        .child(uid)
        .child('places')
        .child(tripName)
        .child(placeKey);

    DatabaseEvent event = (await placeRef.once());
    DataSnapshot dataSnapshot = event.snapshot;

    if (dataSnapshot.value != null) {
      Map<String, dynamic> result =
          Map<String, dynamic>.from(dataSnapshot.value as Map);
      return result;
    } else {
      return null;
    }
  }

  static void deletePlace(String uid, String tripName, String placeKey) {
    database
        .ref()
        .child('users')
        .child('tourist')
        .child(uid)
        .child('places')

        .child(tripName)
        .child(placeKey)
        .remove();
  }

  static Future<void> removeTrip(String uid, String tripName) async {
    DatabaseReference tripRef = database
        .ref()
        .child('users')
        .child('tourist')
        .child(uid)
        .child('places')

        .child(tripName);

    await tripRef.remove();
  }

  static Future<void> updateTripName(
      String uid, String oldTripName, String newTripName) async {
    try {
      DatabaseReference userRef = database
          .ref()
          .child('users')
          .child('tourist')
          .child(uid)
          .child('places');
      DataSnapshot dataSnapshot =
          (await userRef.child(oldTripName).once()).snapshot;

      if (dataSnapshot.value != null) {
        Map<String, dynamic> placesData =
            Map<String, dynamic>.from(dataSnapshot.value as Map);
        await userRef.child(newTripName).set(placesData);
        await userRef.child(oldTripName).remove();
      } else {
        throw Exception('Trip not found');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Error updating trip name');
    }
  }
}
