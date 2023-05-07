// lib/providers/auth_provider.dart
import 'package:google_maps_basics/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_basics/model/user.dart' as AppUser;
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_basics/model/transport_owner.dart';

class AuthProvider with ChangeNotifier {
  final AuthService authService;

  // Add this constructor
  AuthProvider({required this.authService});

  AppUser.User? _currentUser; // Make _currentUser nullable

  AppUser.User? get currentUser => _currentUser;

  // Add the signOut method
  Future<void> signOut() async {
    // Perform the sign-out action (e.g., using Firebase Auth)
    _currentUser = null;
    notifyListeners();
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password, bool isTransportOwner) async {
    // Perform registration with email and password (e.g., using Firebase Auth)
    // Set the current user based on the registration result
    try {
      // Example using Firebase Auth
      final auth = FirebaseAuth.FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set the current user based on the registration result
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Save the user data to the Realtime Database or Firestore
        final databaseReference = FirebaseDatabase.instance.reference();
        String uid = firebaseUser.uid;
        if (isTransportOwner) {
          // Save the transport owner data
          databaseReference.child('transport_owners').child(uid).set({
            'email': email,
            'companyName': '', // Set the initial company name and contact number as empty
            'contactNumber': '',
          });
        } else {
          // Save the user data
          databaseReference.child('users').child(uid).set({
            'email': email,
            'isTransportOwner': false,
          });
        }
        // Update the _currentUser field in AuthProvider
        _currentUser = isTransportOwner
            ? TransportOwner(id: uid, email: email, companyName: '', contactNumber: '')
            : AppUser.User(id: uid, email: email, isTransportOwner: false);

        notifyListeners();
      }
    } catch (e) {
      // Handle registration error
      print('Registration error: $e');
      throw e;
    }
  }

  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    // Perform login with email and password (e.g., using Firebase Auth)
    // Set the current user based on the login result
    try {
      // Example using Firebase Auth
      final auth = FirebaseAuth.FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set the current user based on the login result
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Retrieve the user data from the Realtime Database or Firestore
        final databaseReference = FirebaseDatabase.instance.reference();
        String uid = firebaseUser.uid;

// Check if the user is a transport owner
        DataSnapshot transportOwnerSnapshot = (await databaseReference.child('transport_owners').child(uid).once()).snapshot;
        if (transportOwnerSnapshot.exists) {
          // The user is a transport owner
          _currentUser = TransportOwner(
            id: uid,
            email: (transportOwnerSnapshot.value as Map<String, dynamic>)['email'] ?? '',
            companyName: (transportOwnerSnapshot.value as Map<String, dynamic>)['companyName'] ?? '',
            contactNumber: (transportOwnerSnapshot.value as Map<String, dynamic>)['contactNumber'] ?? '',
          );
        } else {
          // The user is not a transport owner
          DataSnapshot userSnapshot = (await databaseReference.child('users').child(uid).once()).snapshot;
          _currentUser = AppUser.User(
            id: uid,
            email: (userSnapshot.value as Map<String, dynamic>)['email'] ?? '',
            isTransportOwner: (userSnapshot.value as Map<String, dynamic>)['isTransportOwner'] ?? false,
          );
        }




        notifyListeners();
      }
    } catch (e) {
      // Handle login error
      print('Login error: $e');
      throw e;
    }
  }

}