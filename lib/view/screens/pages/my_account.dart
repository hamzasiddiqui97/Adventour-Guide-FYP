import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/core/widgets/bottom_underlined_custom_button.dart';
import 'package:google_maps_basics/core/widgets/rounded_button.dart';


class MyAccount extends StatelessWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
                children:  const [
                  SizedBox(
                    height: 100,
                    child: Icon(
                      Icons.person,
                      size: 70.0,
                      color: ColorPalette.secondaryColor,),
                  ),
                ],
              ),
              const Text('Login for better Experience', style: TextStyle(fontSize: 16.0),),
              RoundedButton(name: 'Login', color: ColorPalette.secondaryColor,width: 200.0,),
              UnderlineButton(name: 'All my plans', color: Colors.transparent,textColor: Colors.black, width:  screenWidth,),
              UnderlineButton(name: 'Contact us', color: Colors.transparent,textColor: Colors.black, width:  screenWidth,),
              UnderlineButton(name: 'Privacy policy', color: Colors.transparent,textColor: Colors.black, width:screenWidth,),
              UnderlineButton(name: 'Terms and Condition', color: Colors.transparent,textColor: Colors.black, width:  screenWidth,),
              UnderlineButton(name: 'Delete my account', color: Colors.transparent,textColor: Colors.black, width:  screenWidth,),
            ],

          ),
        ),
      ),
    );
  }
}
