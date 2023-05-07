import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/snackbar_utils.dart';
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

  final hotelNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isConfirmObscure = true;

  final _formKey = GlobalKey<FormState>();
  String? _hotelNameError;
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
      _hotelNameError =
      hotelNameController.text.isEmpty ? 'Please enter a hotel name' : null;

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
                TextFormField(
                  controller: hotelNameController,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Hotel Name',
                    errorText: _emailError,
                    prefixIcon: const Icon(
                      Icons.person_pin_circle_rounded,
                      size: 30,
                    ),
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
                    onPressed: signUp,
                    // onPressed: () {
                    //   validateInputs();
                    //   signUp;
                    //   },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontSize: 20),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
  // Future signUpxd() async {
  //   final isValid = _formKey.currentState!.validate();
  //   if (!isValid) return;
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) =>
  //     const Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //   );
  //   try {
  //     if (passwordController.text == confirmPasswordController.text) {
  //       UserCredential userCredential =
  //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: emailController.text.trim(),
  //         password: passwordController.text.trim(),
  //       );
  //
  //       // Get the UID of the newly created user
  //       // User has been successfully registered
  //       // adding to the database
  //       String uid = userCredential.user!.uid;
  //
  //       addPlacesToFirebaseDb.saveUserCredentials(
  //           uid, emailController.text.trim(), mainController.role.value);
  //       print('sign up: uid of user: $uid');
  //       print('sign up: role: ${mainController.role.value}');
  //
  //       Utils.showSnackBar("Account is created Sucessfully!", true);
  //       Navigator.of(context).pop(); // Dismiss the progress dialog
  //
  //       // Navigate to the correct page based on the user's role
  //       if (mainController.role.value == "Tourist") {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => NavigationPage(uid: uid)),
  //         );
  //       } else if (mainController.role.value == "Hotel Owner") {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => HotelOwnerPage(uid: uid)),
  //         );
  //       } else if (mainController.role.value == "Transport Owner") {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => TransportationOwnerPage(uid: uid)),
  //         );
  //       }
  //     } else {
  //       // Password and Confirm Password do not match
  //       throw FirebaseAuthException(
  //           code: "passwords-dont-match",
  //           message: "Password and Confirm Password do not match.");
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     String errorMessage = "An error occurred while signing up.";
  //     if (e.code == "email-already-in-use") {
  //       errorMessage = "The email address is already in use.";
  //     } else if (e.code == "invalid-email") {
  //       errorMessage = "The email address is invalid.";
  //     } else if (e.code == "weak-password") {
  //       errorMessage = "The password is too weak.";
  //     } else if (e.code == "passwords-dont-match") {
  //       errorMessage = "Password and Confirm Password do not match.";
  //     }
  //     Utils.showSnackBar(errorMessage, false);
  //   } catch (e) {
  //     Utils.showSnackBar("An error occurred while signing up.", false);
  //   } finally {
  //     Navigator.of(context).pop(); // Dismiss the progress dialog
  //   }
  // }


  Future signUp() async {
    final isValid = _formKey.currentState!.validate();
    // if (!isValid) return;
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

        // User has been successfully registered
        // Add any additional actions to be performed after successful registration
        //adding to the database

        String uid = userCredential.user!.uid;

        addPlacesToFirebaseDb.saveUserCredentials(
            uid, emailController.text.trim(), mainController.role.value);
        print('sign up: uid of user: $uid');
        print('sign up: role: ${mainController.role.value}');

        // if (mainController.role.value == "Tourist") {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => NavigationPage(uid: uid)),
        //   );
        // }
        // else if (mainController.role.value == "Hotel Owner") {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => HotelOwnerPage(uid: uid)),
        //   );
        Get.off(()=> HotelOwnerPage(uid: uid,));
        // }
        // else if (mainController.role.value == "Transport Owner") {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => TransportationOwnerPage(uid: uid)),
        //   );
        // }

        Utils.showSnackBar("Account is created Sucessfully!", true);

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
      Utils.showSnackBar("An error occurred while signing up", false);
    } finally {
      Navigator.of(context).pop(); // Dismiss the progress dialog
    }
  }
}

// class HotelOwnerSignUpDetail extends StatefulWidget {
//   const HotelOwnerSignUpDetail({
//     Key? key,
//     required this.hotelNameController,
//     required this.emailNameController,
//     required this.passwordController,
//     required this.fireStore,
//   }) : super(key: key);
//
//   final String hotelNameController;
//   final String emailNameController;
//   final String passwordController;
//   final FirebaseFirestore fireStore;
//
//   @override
//   State<HotelOwnerSignUpDetail> createState() =>
//       _HotelOwnerSignUpDetailState(
//         hotelNameController,
//         emailNameController,
//         passwordController,
//         fireStore,
//       );
// }

// class _HotelOwnerSignUpDetailState extends State<HotelOwnerSignUpDetail> {
//   final String hotelNameController;
//   final String emailNameController;
//   final String passwordController;
//   final FirebaseFirestore fireStore;
//   File? _image1;
//   File? _image2;
//   File? _image3;
//   String? image1Url;
//   String? image2Url;
//   String? image3Url;
//   final picker = ImagePicker();
//
//   _HotelOwnerSignUpDetailState(this.hotelNameController,
//       this.emailNameController, this.passwordController, this.fireStore);
//
//   Future<void> _getImage1({required ImageSource source}) async {
//     PickedFile? pickedFile = await ImagePicker().getImage(
//       source: ImageSource.gallery,
//       maxWidth: 1800,
//       maxHeight: 1800,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         _image1 = File(pickedFile.path);
//       });
//     }
//     if (_image1 == null) return;
//     //Import dart:core
//     String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
//
//     /*Step 2: Upload to Firebase storage*/
//     //Install firebase_storage
//     //Import the library
//
//     //Get a reference to storage root
//     Reference referenceRoot = FirebaseStorage.instance.ref();
//     Reference referenceDirImages = referenceRoot.child('images');
//
//     //Create a reference for the image to be stored
//     Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
//
//     //Handle errors/success
//     try {
//       //Store the file
//       await referenceImageToUpload.putFile(
//         File(
//           _image1!.path,
//         ),
//       );
//       //Success: get the download URL
//       image1Url = await referenceImageToUpload.getDownloadURL();
//       print(image1Url);
//     } catch (error) {
//       //Some error occurred
//     }
// }
//
// Future<void> _getImage2({required ImageSource source}) async {
//   PickedFile? pickedFile = await ImagePicker().getImage(
//     source: ImageSource.gallery,
//     maxWidth: 1800,
//     maxHeight: 1800,
//   );
//   if (pickedFile != null) {
//     setState(() {
//       _image2 = File(pickedFile.path);
//     });
//   }
//   if (_image2 == null) return;
//   //Import dart:core
//   String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
//
//   /*Step 2: Upload to Firebase storage*/
//   //Install firebase_storage
//   //Import the library
//
//   //Get a reference to storage root
//   Reference referenceRoot = FirebaseStorage.instance.ref();
//   Reference referenceDirImages = referenceRoot.child('images');
//
//   //Create a reference for the image to be stored
//   Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
//
//   //Handle errors/success
//   try {
//     //Store the file
//     await referenceImageToUpload.putFile(
//       File(
//         _image2!.path,
//       ),
//     );
//     //Success: get the download URL
//     image2Url = await referenceImageToUpload.getDownloadURL();
//     print(image2Url);
//   } catch (error) {
//     //Some error occurred
//   }
// }
//
// Future<void> _getImage3({required ImageSource source}) async {
//   PickedFile? pickedFile = await ImagePicker().getImage(
//     source: ImageSource.gallery,
//     maxWidth: 1800,
//     maxHeight: 1800,
//   );
//   if (pickedFile != null) {
//     setState(() {
//       _image3 = File(pickedFile.path);
//     });
//   }
//   if (_image3 == null) return;
//   //Import dart:core
//   String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
//
//   /*Step 2: Upload to Firebase storage*/
//   //Install firebase_storage
//   //Import the library
//
//   //Get a reference to storage root
//   Reference referenceRoot = FirebaseStorage.instance.ref();
//   Reference referenceDirImages = referenceRoot.child('images');
//
//   //Create a reference for the image to be stored
//   Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
//
//   //Handle errors/success
//   try {
//     //Store the file
//     await referenceImageToUpload.putFile(
//       File(
//         _image3!.path,
//       ),
//     );
//     //Success: get the download URL
//     image3Url = await referenceImageToUpload.getDownloadURL();
//     print(image3Url);
//   } catch (error) {
//     //Some error occurred
//   }
// }
//
// @override
// Widget build(BuildContext context) {
//
//   return Scaffold(
//     body: SafeArea(
//       child: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Lottie.asset(
//                 'assets/splash_screen_animation/hotelSignUpDetail.json',
//                 height: 160),
//             const SizedBox(
//               height: 30,
//             ),
//             const Text(
//               'Hotel Details',
//               style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
//             ),
//
//             const SizedBox(
//               height: 30,
//             ),
//             const Text(
//               "Select Images",
//               style: TextStyle(fontSize: 22),
//               textAlign: TextAlign.start,
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Container(
//               height: 100,
//               width: 310,
//               padding: const EdgeInsets.symmetric(horizontal: 50),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.all(
//                   Radius.circular(
//                     10,
//                   ),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 5,
//                     blurRadius: 10,
//                     offset: const Offset(0, 3), // changes position of shadow
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     height: 40,
//                     width: 40,
//                     decoration: BoxDecoration(
//                       // color: Colors.black,
//                       border: Border.all(width: 1.0, color: Colors.grey),
//                       borderRadius: BorderRadius.circular(5.0),
//                       // dashPattern: [6, 3], // [dash length, space length]
//                     ),
//                     child: Center(
//                       child: _image1 == null
//                           ? IconButton(
//                         onPressed: () {
//                           _getImage1(
//                             source: ImageSource.gallery,
//                             // fileName: _image1!,
//                           );
//                         },
//                         icon: const Icon(
//                           Icons.add,
//                         ),
//                       )
//                           : Image.file(
//                         _image1!,
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: 40,
//                     width: 40,
//                     decoration: BoxDecoration(
//                       // color: Colors.black,
//                       border: Border.all(width: 1.0, color: Colors.grey),
//                       borderRadius: BorderRadius.circular(5.0),
//                       // dashPattern: [6, 3], // [dash length, space length]
//                     ),
//                     child: Center(
//                       child: _image2 == null
//                           ? IconButton(
//                         onPressed: () {
//                           _getImage2(
//                             source: ImageSource.gallery,
//                             // fileName: _image1!,
//                           );
//                         },
//                         icon: const Icon(
//                           Icons.add,
//                         ),
//                       )
//                           : Image.file(
//                         _image2!,
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       _getImage3(
//                         source: ImageSource.gallery,
//                       );
//                     },
//                     child: Container(
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         // color: Colors.black,
//                         border: Border.all(width: 1.0, color: Colors.grey),
//                         borderRadius: BorderRadius.circular(5.0),
//                         // dashPattern: [6, 3], // [dash length, space length]
//                       ),
//                       child: _image3 == null
//                           ? IconButton(
//                         onPressed: () {
//                           _getImage3(
//                             source: ImageSource.gallery,
//                             // fileName: _image1!,
//                           );
//                         },
//                         icon: const Icon(
//                           Icons.add,
//                         ),
//                       )
//                           : Image.file(
//                         _image3!,
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(
//               height: 20,
//             ),
//             InkWell(
//               onTap: () {
//                 Get.to(
//                   MySample(),
//                 );
//               },
//               child: Container(
//                 height: 50,
//                 width: 200,
//                 decoration: const BoxDecoration(
//                   color: Colors.orangeAccent,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(
//                       10,
//                     ),
//                   ),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     "Enter Card Details",
//                     style: TextStyle(
//                       fontSize: 19,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             InkWell(
//               onTap: () {
//                 // Get.to(
//                 //   MySample(),
//                 // );
//
//                 AddPlacesToFirebaseDb().hotelOwnerSignup(
//                   // uid,
//                   emailNameController,
//                   hotelNameController,
//                   "hotel owner",
//                   image1Url!,
//                   image2Url!,
//                   image3Url!,
//                 );
//                 Utils.showSnackBar("Account is created Sucessfully!", true);
//
//                 Get.offAll(HotelOwnerPage());
//               },
//               child: Container(
//                 height: 50,
//                 width: 200,
//                 decoration: const BoxDecoration(
//                   color: Colors.orangeAccent,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(
//                       10,
//                     ),
//                   ),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     "Confirm",
//                     style: TextStyle(
//                       fontSize: 19,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // TextFormField(
//             //   controller: hotelNameController,
//             //   cursorColor: Colors.black,
//             //   textInputAction: TextInputAction.next,
//             //   decoration: InputDecoration(
//             //     labelText: 'Hotel Name',
//             //     errorText: _emailError,
//             //     prefixIcon: const Icon(Icons.person_pin_circle_rounded,size: 30,),
//             //   ),
//             //   onChanged: (value) {
//             //     validateInputs();
//             //   },
//             //   autofillHints: const [AutofillHints.email],
//             // ),
//             const SizedBox(
//               height: 12,
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }}

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
}
