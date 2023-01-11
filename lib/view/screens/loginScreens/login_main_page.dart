import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_basics/view/screens/pages/main_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential authResult =
    await _auth.signInWithCredential(credential);
    final User? user = authResult.user;

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      print("Error signing in with Google");
    }
  }

  Future<void> _signInAnonymously() async {
    try {
      final UserCredential authResult = await _auth.signInAnonymously();
      final User? user = authResult.user;

      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        print("Error signing in anonymously");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: const Text('Sign in with Google'),
            ),
            ElevatedButton(
              child: const Text('Sign in'),
              onPressed: () {
                Navigator.pushNamed(context, '/signIn');
              },
            ),
            ElevatedButton(
              child: const Text('Sign up'),
              onPressed: () {
                Navigator.pushNamed(context, '/signUp');
              },
            ),
            // ElevatedButton(
            //   onPressed: _signInAnonymously,
            //   child: const Text('Guest login'),
            // ),
            const SizedBox(height: 40.0,),
            GestureDetector(
              onTap: (){
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text("Maybe Later",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,)),
            ),

          ],
        ),
      ),
    );
  }
}
