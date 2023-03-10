import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/main.dart';
import 'package:google_maps_basics/snackbar_utils.dart';
import 'package:google_maps_basics/view/screens/loginScreens/forgot_password.dart';
import 'package:lottie/lottie.dart';
import 'onboarding_screen.dart';

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
                    child: const Text('Forgot Password?',
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        color: ColorPalette.secondaryColor,
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ForgotPasswordPage()))
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      validateInputs();
                      if (_formKey.currentState!.validate()) {
                        signIn();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          ColorPalette.secondaryColor),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          ColorPalette.primaryColor),
                    ),
                    child: const Text('Sign In'),
                  ),
                ),

                const SizedBox(
                  height: 20,
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
              ],
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
          barrierDismissible: false,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        // Check if the sign-in was successful
        if (FirebaseAuth.instance.currentUser != null) {
          // Navigate to the onboarding screen
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const OnboardingScreen()));
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
        Utils.showSnackBar(e.message);
      }

      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }
}
