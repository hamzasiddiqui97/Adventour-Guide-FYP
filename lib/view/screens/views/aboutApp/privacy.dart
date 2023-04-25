import 'package:flutter/material.dart';

import '../../../../core/constant/color_constants.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar
          (
          elevation: 0,
          backgroundColor: ColorPalette.secondaryColor,
          foregroundColor: ColorPalette.primaryColor,
          title: const Text('Privacy Policy'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          children: const <Widget>[
            Text(
              'We take privacy seriously and understand that the personal information of our users is sensitive and should be protected. This privacy policy explains how we collect, use, and safeguard your information when you use our travel mobile app. By using our app, you agree to this privacy policy.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Information Collection:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'When you use our app, we may collect certain information such as your name, email address, phone number, and payment information. We may also collect information about your travel plans, location, and preferences. This information is necessary to provide you with a better travel experience and improve our app.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Information Usage:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'We use your personal information to provide you with the travel services you request through our app. We may also use your information to personalize your experience, send you promotional offers, and communicate with you about your bookings. We do not sell your personal information to third-party companies for marketing purposes.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Information Sharing:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'We may share your personal information with third-party service providers such as airlines, hotels, car rental companies, and travel insurance providers in order to facilitate your bookings. We may also share your information with law enforcement agencies, government authorities, or other third parties if required by law.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Data Security:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'We take all reasonable measures to protect your personal information from unauthorized access, disclosure, alteration, or destruction. We use secure encryption technologies to safeguard your information and implement strict access controls to ensure that only authorized personnel have access to your data.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Data Retention:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'We retain your personal information for as long as necessary to fulfill the purposes for which it was collected. We may retain your information for a longer period of time if required by law.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
