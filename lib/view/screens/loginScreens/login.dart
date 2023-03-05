import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/main.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void validateInputs() {
    setState(() {
      _emailError = emailController.text.isEmpty || !emailController.text.contains('@')
          ? 'Please enter a valid email'
          : null;

      _passwordError = passwordController.text.isEmpty ? 'Please enter your password' : null;
    });
  }


  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Login or Sign Up', style: TextStyle(fontSize: 30),),

                const SizedBox(height: 20,),
                TextFormField(
                  controller: emailController,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: _emailError,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  onChanged: (value) {
                    validateInputs();
                  },
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Please enter your email';
                  //   }
                  //   if (!value.contains('@')) {
                  //     return 'Please enter a valid email';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: _passwordError,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  obscureText: _isObscure,
                  onChanged: (value) {
                    validateInputs();
                  },
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Please enter your password';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: signIn,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(ColorPalette.secondaryColor),
                    foregroundColor: MaterialStateProperty.all<Color>(ColorPalette.primaryColor),
                  ),
                  child: const Text('Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ));

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
      } on FirebaseAuthException catch (e) {
        print(e);
        if (e.code == 'user-not-found') {
          setState(() {
            _emailError = 'User not found';
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sign In Failed'),
                content: const Text(
                    'The email address you entered does not belong to an account.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (e.code == 'wrong-password') {
          setState(() {
            _passwordError = 'Incorrect password';
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sign In Failed'),
                content: const Text('The password you entered is incorrect.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          setState(() {
            _emailError = 'Unknown error occurred';
          });
        }
      }
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }
}
