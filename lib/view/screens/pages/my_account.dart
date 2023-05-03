import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/core/widgets/bottom_underlined_custom_button.dart';
import 'package:google_maps_basics/core/widgets/rounded_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../views/aboutApp/contact_us.dart';
import '../views/aboutApp/delete_account.dart';
import '../views/aboutApp/privacy.dart';
import '../views/aboutApp/term_conds.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    return
      Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: ColorPalette.secondaryColor,
          foregroundColor: ColorPalette.primaryColor,
          title: const Text('Account Details'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: user?.photoURL != null
                        ? CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoURL!),
                      radius: 48,
                    ) :const Icon(
                      Icons.person,
                      size: 70.0,
                      color: ColorPalette.secondaryColor,
                    ),
                  ),
                ],
              ),
              if (user != null) ...[
                const SizedBox(height: 15),
                Text('Logged in as: ${user.displayName}',style: const TextStyle(fontSize: 16.0,)),
                Text('Email: ${user.email}', style: const TextStyle(fontSize: 16.0,)),
                const SizedBox(height: 20),

                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      await GoogleSignIn().signOut();
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: ColorPalette.primaryColor,
                      backgroundColor: ColorPalette.secondaryColor,
                    ),
                    child: const Text('Sign Out', ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 20),
                const Text('Login for better Experience', style: TextStyle(fontSize: 16.0)),
                RoundedButton(
                  name: 'Login',
                  color: ColorPalette.secondaryColor,
                  width: 200.0,
                  onPress: () {
                    // Open login page and set display name on successful login
                    Navigator.pushNamed(context, '/login').then((displayName) {
                      if (displayName != null) {
                        // _setDisplayName(displayName.toString());
                      }
                    });
                  },
                ),
              ],
              const SizedBox(height: 20),
              // UnderlineButton(name: 'All my plans', color: Colors.transparent,textColor: Colors.black, width: screenWidth,),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUsPage()));
                },
                  child: UnderlineButton(
                    name: 'Contact us',
                    color: Colors.transparent,
                    textColor: Colors.black,
                    width: screenWidth,)),
              InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()));
                  },
                  child: UnderlineButton(name: 'Privacy policy', color: Colors.transparent,textColor: Colors.black, width:screenWidth,)),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsAndConditionsPage()));
                },
                child: UnderlineButton(
                  name: 'Terms and Condition', color: Colors.transparent,textColor: Colors.black, width: screenWidth,),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteAccountPage()));
                  },
                enableFeedback: true,
                child: UnderlineButton(
                  name: 'Delete my account', color: Colors.transparent,textColor: Colors.black, width:  screenWidth,),
              ),
            ],
          ),
        ),
      );
  }
}
