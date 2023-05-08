import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/snackbar_utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import '../../../controllers/mainController.dart';
import '../../../hotel_owner_dummy_screen.dart';
import '../../../model/firebase_reference.dart';
import '../../../transport_owner_dummy_screen.dart';
import '../pages/main_page.dart';

class SignUp extends StatefulWidget {
  final VoidCallback onClickSignIn;

  // final int? signIndex;

  const SignUp({
    Key? key,
    required this.onClickSignIn,
    // required this.signIndex,
  }) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // FirebaseFirestore fireStore = FirebaseFirestore.instance;
  AddPlacesToFirebaseDb addPlacesToFirebaseDb = AddPlacesToFirebaseDb();
  final MainController mainController = Get.put(MainController());

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
    return WillPopScope(
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
                      icon: Icon(_isConfirmObscure
                          ? Icons.visibility_off
                          : Icons.visibility),
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
                    minimumSize: const Size(double.infinity, 40),
                  ),

                  child: const Text('Sign Up'),
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    text: 'Already have an account?  ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickSignIn,
                        text: 'Log In',
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
                ElevatedButton(
                  onPressed: signUpTouristWithGoogle,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.secondaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 40),
                  ),

                  child: const Text('Sign Up with Google'),
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
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // Get the UID of the newly created user
        String uid = userCredential.user!.uid;
        AddPlacesToFirebaseDb addPlacesToFirebaseDb = AddPlacesToFirebaseDb();
        // User has been successfully registered
        // adding to the database

        addPlacesToFirebaseDb.saveUserCredentials(
            uid, emailController.text.trim(), mainController.role.value);
        Utils.showSnackBar("Account is created Successfully!", true);
        print('sign up: uid of user: $uid');
        print('sign up: role: ${mainController.role.value}');
        Navigator.of(context).pop(); // Dismiss the progress dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationPage(uid: uid)),
        );
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
      Utils.showSnackBar(errorMessage, false);
    } catch (e) {
      Utils.showSnackBar("An error occurred while signing up.", false);
    } finally {
      Navigator.of(context).pop(); // Dismiss the progress dialog
    }
  }

  signUpTouristWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print('Sign up success\nUsername: ${userCredential.user?.displayName}');

      // Get the user's UID
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Create a new user in the Firestore database with the obtained user data
      AddPlacesToFirebaseDb addPlacesToFirebaseDb = AddPlacesToFirebaseDb();

      // Save the new user's data in the  database
      await addPlacesToFirebaseDb.createUserUsingGoogleSignUp(uid, googleUser?.email ?? '', mainController.role.value);

      // Navigate to the appropriate screen based on the user role
      if (mainController.role.value == "Tourist") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => NavigationPage(uid: uid),
          ),
        );
      } else if (mainController.role.value == "Hotel Owner") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HotelOwnerPage(uid: uid),
          ),
        );
      } else if (mainController.role.value == "Transport Owner") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TransportationOwnerPage(uid: uid),
          ),
        );
      } else {
        Utils.showSnackBar("Invalid role. Please contact support.", false);
      }
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

class HotelOwnerSignUp extends StatefulWidget {
  final VoidCallback onClickSignIn;

  // final int? signIndex;

  const HotelOwnerSignUp({
    Key? key,
    required this.onClickSignIn,
    // required this.signIndex,
  }) : super(key: key);

  @override
  _HotelOwnerSignUpState createState() => _HotelOwnerSignUpState();
}

class _HotelOwnerSignUpState extends State<HotelOwnerSignUp> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  AddPlacesToFirebaseDb addPlacesToFirebaseDb = AddPlacesToFirebaseDb();
  final MainController mainController = Get.put(MainController());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isConfirmObscure = true;

  final _formKey = GlobalKey<FormState>();
  // String? _hotelNameError;
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
      // _hotelNameError =
      // hotelNameController.text.isEmpty ? 'Please enter a hotel name' : null;

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
    return WillPopScope(
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
                SizedBox(
                  height: 160,
                  width: 160,
                  child: Lottie.asset(
                      'assets/splash_screen_animation/hotelSignUp.json'),
                ),
                const Text(
                  'Hotel Sign Up',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 30,
                ),
                // TextFormField(
                //   controller: hotelNameController,
                //   cursorColor: Colors.black,
                //   textInputAction: TextInputAction.next,
                //   decoration: InputDecoration(
                //     labelText: 'Hotel Name',
                //     errorText: _emailError,
                //     prefixIcon: const Icon(
                //       Icons.person_pin_circle_rounded,
                //       size: 30,
                //     ),
                //   ),
                //   onChanged: (value) {
                //     validateInputs();
                //   },
                //   autofillHints: const [AutofillHints.email],
                // ),
                // const SizedBox(
                //   height: 12,
                // ),
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
                      icon: Icon(_isConfirmObscure
                          ? Icons.visibility_off
                          : Icons.visibility),
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
                  height: 40,
                ),
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 1.2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      backgroundColor: ColorPalette.secondaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    onPressed: signUpForHotelOwner,
                    // onPressed: () {
                    //   validateInputs();
                    //   signUp;
                    //   },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    text: 'Already have an account?  ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickSignIn,
                        text: 'Log In',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: ColorPalette.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),


            const SizedBox(
            height: 40,
          ),
          SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width / 1.2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                backgroundColor: ColorPalette.secondaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
              ),
              onPressed: signUpHotelOwnerWithGoogle,

              child: const Text(
                "SignUp with Google",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.white,),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future signUpForHotelOwner() async {
    validateInputs();
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        String uid = userCredential.user!.uid;

        addPlacesToFirebaseDb.saveUserCredentials(
            uid, emailController.text.trim(), mainController.role.value);
        print('sign up: uid of user: $uid');
        print('sign up: role: ${mainController.role.value}');

        Utils.showSnackBar("Account is created Sucessfully!", true);
        Navigator.of(context).pop(); // Dismiss the progress dialog

        if (mainController.role.value == "Hotel Owner") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HotelOwnerPage(uid: uid)),
          );
        }
      } else {
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
      Utils.showSnackBar(errorMessage, false);
    } catch (e) {
      Utils.showSnackBar("An error occurred while signing up.", false);
    } finally {
      Navigator.of(context).pop(); // Dismiss the progress dialog
    }
  }

  signUpHotelOwnerWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print('Sign up success\nUsername: ${userCredential.user?.displayName}');

      // Get the user's UID
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Create a new user in the Firestore database with the obtained user data
      AddPlacesToFirebaseDb addPlacesToFirebaseDb = AddPlacesToFirebaseDb();

      // Save the new user's data in the  database
      await addPlacesToFirebaseDb.createUserUsingGoogleSignUp(uid, googleUser?.email ?? '', mainController.role.value);

      // Navigate to the appropriate screen based on the user role
      if (mainController.role.value == "Tourist") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => NavigationPage(uid: uid),
          ),
        );
      } else if (mainController.role.value == "Hotel Owner") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HotelOwnerPage(uid: uid),
          ),
        );
      } else if (mainController.role.value == "Transport Owner") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TransportationOwnerPage(uid: uid),
          ),
        );
      } else {
        Utils.showSnackBar("Invalid role. Please contact support.", false);
      }
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


class TransportOwnerSignUp extends StatefulWidget {
  final VoidCallback onClickSignIn;

  // final int? signIndex;

  const TransportOwnerSignUp({
    Key? key,
    required this.onClickSignIn,
    // required this.signIndex,
  }) : super(key: key);

  @override
  _TransportOwnerSignUpState createState() => _TransportOwnerSignUpState();
}

class _TransportOwnerSignUpState extends State<TransportOwnerSignUp> {
  AddPlacesToFirebaseDb addPlacesToFirebaseDb = AddPlacesToFirebaseDb();
  final MainController mainController = Get.put(MainController());

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
    return WillPopScope(
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
                SizedBox(
                  height: 160,
                  width: 160,
                  child: Lottie.asset(
                      'assets/splash_screen_animation/login-hello.json'),
                ),
                const Text(
                  'Transport Sign Up',
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
                      icon: Icon(_isConfirmObscure
                          ? Icons.visibility_off
                          : Icons.visibility),
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
                    minimumSize: const Size(double.infinity, 40),
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
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    text: 'Already have an account?  ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickSignIn,
                        text: 'Log In',
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
                ElevatedButton(
                  onPressed: signUpTransportOwnerWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.secondaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 40),
                  ),

                  child: const Text('Sign Up with Google'),
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
      ),
    );
    try {
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Get the UID of the newly created user
        // User has been successfully registered
        // adding to the database
        String uid = userCredential.user!.uid;

        addPlacesToFirebaseDb.saveUserCredentials(
            uid, emailController.text.trim(), mainController.role.value);
        print('sign up: uid of user: $uid');
        print('sign up: role: ${mainController.role.value}');

        Utils.showSnackBar("Account is created Sucessfully!", true);
        Navigator.of(context).pop(); // Dismiss the progress dialog

        // Navigate to the correct page based on the user's role
        if (mainController.role.value == "Tourist") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavigationPage(uid: uid)),
          );
        } else if (mainController.role.value == "Hotel Owner") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HotelOwnerPage(uid: uid)),
          );
        } else if (mainController.role.value == "Transport Owner") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => TransportationOwnerPage(uid: uid)),
          );
        }
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
      Utils.showSnackBar(errorMessage, false);
    } catch (e) {
      Utils.showSnackBar("An error occurred while signing up.", false);
    } finally {
      Navigator.of(context).pop(); // Dismiss the progress dialog
    }
  }
  signUpTransportOwnerWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print('Sign up success\nUsername: ${userCredential.user?.displayName}');

      // Get the user's UID
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Create a new user in the Firestore database with the obtained user data
      AddPlacesToFirebaseDb addPlacesToFirebaseDb = AddPlacesToFirebaseDb();

      // Save the new user's data in the  database
      await addPlacesToFirebaseDb.createUserUsingGoogleSignUp(uid, googleUser?.email ?? '', mainController.role.value);

      // Navigate to the appropriate screen based on the user role
      if (mainController.role.value == "Tourist") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => NavigationPage(uid: uid),
          ),
        );
      } else if (mainController.role.value == "Hotel Owner") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HotelOwnerPage(uid: uid),
          ),
        );
      } else if (mainController.role.value == "Transport Owner") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TransportationOwnerPage(uid: uid),
          ),
        );
      } else {
        Utils.showSnackBar("Invalid role. Please contact support.", false);
      }
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
