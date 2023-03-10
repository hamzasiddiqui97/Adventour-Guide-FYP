import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constant/color_constants.dart';
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.secondaryColor,
          foregroundColor: ColorPalette.primaryColor,
          centerTitle: true,
          title: const Text('Reset Password'),
          elevation: 0,
          // backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(

            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40,),
                const Text('Forgot your password?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                const SizedBox(height: 20,),
                const Text('Enter an email to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email address';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: resetPassword,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        ColorPalette.secondaryColor),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        ColorPalette.primaryColor),
                  ),
                  child: const Text(
                    'Reset Password', style: TextStyle(color: Colors.white,),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {

    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator(),),);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim());


      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Password reset email sent'),)
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(error.toString()),
        ),
      );

      Navigator.of(context).pop();
    }
  }
}