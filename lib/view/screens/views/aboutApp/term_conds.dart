import 'package:flutter/material.dart';

import '../../../../core/constant/color_constants.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorPalette.secondaryColor,
        foregroundColor: ColorPalette.primaryColor,
        title: const Text('Terms And Conditions'),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        children: const <Widget>[
          Text(
            'Welcome to our Adventour and guide. By using our app, you agree to the following terms and conditions:',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 20.0),
          Text(
            '1. User Conduct',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          Text(
            'You agree to use our app for lawful purposes only and in a manner that does not infringe on the rights of others. You agree to not use our app to transmit any material that is offensive, defamatory, or obscene. You also agree to not use our app to engage in any activity that could harm our app or our users.',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 20.0),
          Text(
            '2. Intellectual Property',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          Text(
            'All content and materials available on our app, including but not limited to text, graphics, logos, images, and software, are the property of our app and are protected by applicable intellectual property laws. You may not use our content or materials for any purpose without our express written consent.',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 20.0),
          Text(
            '3. Disclaimers',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          Text(
            'Our app is provided on an "as is" and "as available" basis. We make no representations or warranties of any kind, express or implied, as to the operation of our app or the information, content, materials, or products included on our app. You use our app at your own risk.',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 20.0),
          Text(
            '4. Limitation of Liability',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          Text(
            'In no event shall our app or our affiliates be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in any way connected with the use of our app or the inability to use our app, whether based on contract, tort, strict liability, or any other legal theory.',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 20.0),
          Text(
            '5. Indemnification',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          Text(
            'You agree to indemnify and hold our app and our affiliates harmless from any claim or demand, including reasonable attorneys\' fees, made by any third-party due to or arising out of your use of our app or your violation of these terms and conditions.',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
