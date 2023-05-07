import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_basics/model/transport_owner.dart';
import 'package:google_maps_basics/model/user.dart' as AppUser;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream for listening to authentication state changes
  Stream<AppUser.User?> get onAuthStateChanged {
    return _auth.authStateChanges().asyncMap(_userFromFirebaseUser);
  }

  // Helper method to convert Firebase User to your custom User model
  Future<AppUser.User?> _userFromFirebaseUser(User? firebaseUser) async {
    if (firebaseUser == null) {
      return null;
    } else {
      // Fetch the user data from the database to check if it is a transport owner.
      DatabaseReference _userRef =
      FirebaseDatabase.instance.reference().child('users').child(firebaseUser.uid);

      DatabaseReference _transportOwnerRef = FirebaseDatabase.instance
          .reference()
          .child('transport_owners')
          .child(firebaseUser.uid);

      // Fetch the user data from 'users' node
      DataSnapshot userDataSnapshot = await _userRef.get();
      Map<String, dynamic>? userData = userDataSnapshot.value as Map<String, dynamic>?;

      if (userData != null) {
        // The user exists in the 'users' node
        bool isTransportOwner = userData['isTransportOwner'];
        return AppUser.User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          isTransportOwner: isTransportOwner,
        );
      } else {
        // The user exists in the 'transport_owners' node
        DataSnapshot transportOwnerDataSnapshot = await _transportOwnerRef.get();
        Map<String, dynamic>? transportOwnerData = transportOwnerDataSnapshot.value as Map<String, dynamic>?;

        if (transportOwnerData != null) {
          String companyName = transportOwnerData['companyName'] ?? '';
          String contactNumber = transportOwnerData['contactNumber'] ?? '';

          return TransportOwner(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            companyName: companyName,
            contactNumber: contactNumber,
          );
        } else {
          return null;
        }
      }

    }
  }
}
