import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/core/widgets/bottom_underlined_custom_button.dart';
import 'package:google_maps_basics/core/widgets/rounded_button.dart';


class MyAccount extends StatelessWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
              RoundedButton(name: 'Sign In', color: ColorPalette.secondaryColor,width: 200.0,),
              UnderlineButton(name: 'All my plans', color: Colors.transparent,textColor: Colors.black, width:  300.0,),
              UnderlineButton(name: 'Contact us', color: Colors.transparent,textColor: Colors.black, width:  300.0,),
              UnderlineButton(name: 'Privacy policy', color: Colors.transparent,textColor: Colors.black, width:  300.0,),
              UnderlineButton(name: 'Terms and Condition', color: Colors.transparent,textColor: Colors.black, width:  300.0,),
              UnderlineButton(name: 'Delete my account', color: Colors.transparent,textColor: Colors.black, width:  300.0,),
            ],

          ),
        ),
      ),
    );
  }
}
