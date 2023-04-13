import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_basics/view/screens/loginScreens/auth_page.dart';
import '../../../../snackbar_utils.dart';

class DeleteAccountPage extends StatefulWidget {
  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteAccount() async {
    User? user = _auth.currentUser;

    if (user == null) {
      print("User not found.");
      return;
    }

    try {
      // Delete the user's data from Cloud Firestore
      await _firestore.collection('Tourist').doc(user.uid).delete();

      // Delete the user from Firebase Authentication
      await user.delete();
      Utils.showSnackBar("Account deleted successfully.", true);

      // Navigate to the LoginPage after account deletion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );

    } catch (e) {
      print("Error: $e");
      Utils.showSnackBar("An error occurred while deleting the account.", false);

    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Delete Account')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Are you sure you want to delete your account?'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  deleteAccount();
                },
                child: const Text('Delete My Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
