import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class AddPlacesToFirebaseDb {
  static final database = FirebaseDatabase.instance;



  Future<void> saveUserCredentials(
      String uid, String email, String role) async {
    try {
      await database
          .ref()
          .child('users')
          .child(role.toLowerCase())
          .child(uid)
          .child('credential')
          .set({'email': email, 'role': role});
    } catch (e) {
      print('Error saving user credentials: $e');
    }
  }

  Future<String> getUserRole(String uid) async {
    String userRole = "";
    DatabaseReference userRef = database.ref().child('users');

    try {
      await userRef.onValue.first.then((DatabaseEvent event) {
        DataSnapshot dataSnapshot = event.snapshot;
        if (dataSnapshot.exists) {
          Map<dynamic, dynamic>? usersData = dataSnapshot.value as Map<dynamic, dynamic>?;
          if (usersData != null) {
            for (String role in usersData.keys) {
              if (usersData[role]?[uid] != null) {
                userRole = usersData[role][uid]['credential']['role'];
                break;
              }
            }
          }
        }
      });
    } catch (e) {
      print('Error getting user role: $e');
    }

    print('user role using getUserRole funtion: $userRole');
    return userRole;
  }

  Future<String> checkUserExistsWithEmail(String email) async {
    String existingRole = '';

    // Get a reference to the users node in the Realtime Database
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');

    // Query the users node for a child with the given email
    DatabaseEvent dataSnapshotEvent = await usersRef.orderByChild('email').equalTo(email).once();

    // Get the DataSnapshot from the DatabaseEvent
    DataSnapshot dataSnapshot = dataSnapshotEvent.snapshot;

    // Check if a user with the given email exists
    if (dataSnapshot.value != null) {
      // Get the user's role from the snapshot
      Map<dynamic, dynamic> userMap = dataSnapshot.value as Map<dynamic, dynamic>;
      existingRole = userMap.values.first['role'];
    }

    return existingRole;
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
