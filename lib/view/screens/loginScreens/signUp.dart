import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/main.dart';
import 'package:google_maps_basics/snackbar_utils.dart';
import 'package:lottie/lottie.dart';

class SignUp extends StatefulWidget {
  final VoidCallback onClickSignIn;

  const SignUp({
    Key? key,
    required this.onClickSignIn,
  }) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isConfirmObscure = true;

  final _formKey = GlobalKey<FormState>();
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void validateInputs() {
    setState(() {
      _emailError =
      emailController.text.isEmpty || !emailController.text.contains('@')
          ? 'Please enter a valid email address'
          : null;

      _passwordError = passwordController.text.length < 6
          ? 'Password must be at least 6 characters'
          : null;

      _confirmPasswordError =
      passwordController.text != confirmPasswordController.text
          ? 'Passwords do not match'
          : null;
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
                Container(
                  height: 160,
                  width: 160,
                  child: Lottie.asset(
                      'assets/splash_screen_animation/login-hello.json'),
                ),
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 20,
                ),
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
                  autofillHints: const [AutofillHints.email],
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
                      icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility),
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
                ),

                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                  controller: confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    errorText: _confirmPasswordError,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isConfirmObscure ? Icons.visibility_off : Icons
                              .visibility),
                      onPressed: () {
                        setState(() {
                          _isConfirmObscure = !_isConfirmObscure;
                        });
                      },
                    ),
                  ),
                  obscureText: _isConfirmObscure,
                  onChanged: (value) {
                    validateInputs();
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                ElevatedButton(
                  onPressed: signUp,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.secondaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 40),
                  ),
                  // style: ButtonStyle(
                  //   backgroundColor: MaterialStateProperty.all<Color>(
                  //       ColorPalette.secondaryColor),
                  //   foregroundColor: MaterialStateProperty.all<Color>(
                  //       ColorPalette.primaryColor),
                  // ),
                  child: const Text('Sign Up'),
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    text: 'Already have an account?  ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickSignIn,
                        text: 'Log In',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: ColorPalette.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
        const Center(
          child: CircularProgressIndicator(),
        ));

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // User has been successfully registered
        // Add any additional actions to be performed after successful registration

      } else {
        // Password and Confirm Password do not match
        throw FirebaseAuthException(
            code: "passwords-dont-match",
            message: "Password and Confirm Password do not match.");
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred while signing up.";
      if (e.code == "email-already-in-use") {
        errorMessage = "The email address is already in use.";
      } else if (e.code == "invalid-email") {
        errorMessage = "The email address is invalid.";
      } else if (e.code == "weak-password") {
        errorMessage = "The password is too weak.";
      } else if (e.code == "passwords-dont-match") {
        errorMessage = "Password and Confirm Password do not match.";
      }
      Utils.showSnackBar(errorMessage);
    } catch (e) {
      Utils.showSnackBar("An error occurred while signing up.");
    } finally {
      Navigator.of(context).pop(); // Dismiss the progress dialog
    }
  }
}
