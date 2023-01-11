import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/core/widgets/heading_text.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;
  late String _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeadingText(text: 'Sign Up', style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
                obscureText: true,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                child: const Text('Sign up'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      final newUser = await _auth.createUserWithEmailAndPassword(
                        email: _email,
                        password: _password,
                      );
                      if (newUser != null) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    } catch (e) {
                      showErrorDialog('Email already in use');
                      print(e);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(ColorPalette.secondaryColor)),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK',style: TextStyle(color: ColorPalette.primaryColor),),

            ),
          ],
        );
      },
    );
  }
}
