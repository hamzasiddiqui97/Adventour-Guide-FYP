import 'package:flutter/material.dart';

import '../../../../core/constant/color_constants.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorPalette.secondaryColor,
          foregroundColor: ColorPalette.primaryColor,
          title: const Text('Contact Us'),
          centerTitle: true,
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Contact us for more information:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Email: contact@Adventourapp.com',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Phone: 0324-9213310',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
