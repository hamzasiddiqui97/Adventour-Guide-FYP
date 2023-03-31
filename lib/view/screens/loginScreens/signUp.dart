import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/snackbar_utils.dart';
import 'package:google_maps_basics/view/screens/pages/main_page.dart';
import 'package:lottie/lottie.dart';

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
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

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
                        icon: Icon(_isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
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
                      style: TextStyle(color: Colors.black, fontSize: 16),
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
      ),
    );
  }

  Future signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
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
        //adding to the firestore
        CollectionReference customers = fireStore.collection('Tourist');
        customers.add({
          'Email': emailController.text,
          'Password': passwordController.text
        });
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
  final hotelNameController = TextEditingController();

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
                        icon: Icon(_isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
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
                  // ElevatedButton(
                  //   onPressed: (){},
                  //
                  //   style: ElevatedButton.styleFrom(
                  //
                  //     backgroundColor: ColorPalette.secondaryColor,
                  //     foregroundColor: Colors.white,
                  //     minimumSize: const Size(double.infinity, 40),
                  //   ),
                  //   // style: ButtonStyle(
                  //   //   backgroundColor: MaterialStateProperty.all<Color>(
                  //   //       ColorPalette.secondaryColor),
                  //   //   foregroundColor: MaterialStateProperty.all<Color>(
                  //   //       ColorPalette.primaryColor),
                  //   // ),
                  //   child: const Text('Next'),
                  // ),
                  InkWell(
                    onTap: () {
                      Get.to(() => const HotelOwnerSignUpDetail());
                      // mainController.role.value=radioValue!;
                      // print(mainController.role.value);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const AuthPage()),
                      // );
                    },
                    child: Container(
                      height: 45,
                      width: 180,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              "Next",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.navigate_next_rounded,
                              color: Colors.white,
                              size: 40,
                            )
                          ],
                        ),
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
      ),
    );
  }

  Future signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
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
        //adding to the firestore
        CollectionReference customers = fireStore.collection('Tourist');
        customers.add({
          'Email': emailController.text,
          'Password': passwordController.text
        });
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
      Utils.showSnackBar("An error occurred while signing up.", false);
    } finally {
      Navigator.of(context).pop(); // Dismiss the progress dialog
    }
  }
}

class HotelOwnerSignUpDetail extends StatefulWidget {
  const HotelOwnerSignUpDetail({Key? key}) : super(key: key);

  @override
  State<HotelOwnerSignUpDetail> createState() => _HotelOwnerSignUpDetailState();
}

class _HotelOwnerSignUpDetailState extends State<HotelOwnerSignUpDetail> {
  // final  = TextEditingController();
  // final passwordController = TextEditingController();
  // final confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                  'assets/splash_screen_animation/hotelSignUpDetail.json',
                  height: 160),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Hotel Details',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),

              const SizedBox(
                height: 30,
              ),
              Text(
                "Select Images",
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 140,
                width: 340,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0),
                        // dashPattern: [6, 3], // [dash length, space length]
                      ),
                    ),
                  ],
                ),
              ),

              // TextFormField(
              //   controller: hotelNameController,
              //   cursorColor: Colors.black,
              //   textInputAction: TextInputAction.next,
              //   decoration: InputDecoration(
              //     labelText: 'Hotel Name',
              //     errorText: _emailError,
              //     prefixIcon: const Icon(Icons.person_pin_circle_rounded,size: 30,),
              //   ),
              //   onChanged: (value) {
              //     validateInputs();
              //   },
              //   autofillHints: const [AutofillHints.email],
              // ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
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
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

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
                        icon: Icon(_isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
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
                      style: TextStyle(color: Colors.black, fontSize: 16),
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
      ),
    );
  }

  Future signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
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
        //adding to the firestore
        CollectionReference customers = fireStore.collection('Tourist');
        customers.add({
          'Email': emailController.text,
          'Password': passwordController.text
        });
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
      Utils.showSnackBar("An error occurred while signing up.", false);
    } finally {
      Navigator.of(context).pop(); // Dismiss the progress dialog
    }
  }
}
