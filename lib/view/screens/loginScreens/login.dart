import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/snackbar_utils.dart';
import 'package:google_maps_basics/view/screens/loginScreens/forgot_password.dart';
import 'package:google_maps_basics/view/screens/pages/main_page.dart';
import 'package:lottie/lottie.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  final VoidCallback onClickSignUp;

  const SignIn({
    Key? key,
    required this.onClickSignUp,
  }) : super(key: key);

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
      _emailError =
      emailController.text.isEmpty || !emailController.text.contains('@')
          ? _emailError != null && emailController.text.isEmpty
          ? _emailError
          : null
          : null;

      _passwordError = passwordController.text.isEmpty
          ? _passwordError != null && passwordController.text.isEmpty
          ? _passwordError
          : null
          : null;
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
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
                    'Login',
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emailController,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
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
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            color: ColorPalette.secondaryColor,
                          ),
                        ),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage()))),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  ElevatedButton(
                    onPressed: () {
                      validateInputs();
                      if (_formKey.currentState!.validate()) {
                        signIn();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.secondaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    child: const Text('Sign In'),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      text: 'No Account?  ',
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickSignUp,
                          text: 'Sign Up',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: ColorPalette.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    thickness: 1.0,
                  ),
                  const Text('OR'),
                  ElevatedButton.icon(
                    onPressed: () {
                      signInWithGoogle();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.secondaryColor,
                      foregroundColor: ColorPalette.primaryColor,
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    icon: Image.asset(
                      'assets/images/google_logo.png',
                      width: 24,
                      height: 24,
                    ),
                    label: const Text('Sign In with Google'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    if (_formKey.currentState == null || _formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Dismiss the loading widget
      Navigator.of(context).pop();

      // Check if the sign-in was successful
      if (FirebaseAuth.instance.currentUser != null) {

        // Get the user's UID
        String uid = FirebaseAuth.instance.currentUser!.uid;
        print('Get the users UID: ${uid.toString()}');

        // Navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => NavigationPage(uid: uid,),
          ),
        );

      } else {
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
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'User not found. Please check your email address.';
          break;
        case 'wrong-password':
          errorMessage = 'The password you entered is incorrect.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address you entered is invalid.';
          break;
        default:
          errorMessage = 'Sign in failed. Please try again later.';
          break;
      }
      // Dismiss the loading widget
      Navigator.of(context).pop();
      Utils.showSnackBar(errorMessage,false);
    } catch (e) {
      // Dismiss the loading widget
      Navigator.of(context).pop();
      Utils.showSnackBar('Sign in failed. Please try again later.',false);
    }
  }
  signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print('Sign in success\n Username: ${userCredential.user?.displayName}');


      // Get the user's UID
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Navigate to the home screen after successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationPage(uid: uid)),
      );
    } catch (e) {
      if (e is PlatformException) {
        // Handle the exception here
        print('Error: ${e.code} - ${e.message}');
      } else {
        // Handle other exceptions here
        print('Error: $e');
      }
    }
  }
}