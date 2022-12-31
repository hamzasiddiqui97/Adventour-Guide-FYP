import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
//
// class MyAccount extends StatelessWidget {
//   const MyAccount({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(child: Center(child: Text('My Account')),);
//   }
// }


class MyAccount extends StatelessWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back_ios,color: ColorPalette.secondaryColor,),
                  Icon(Icons.person,color: ColorPalette.secondaryColor,size: 40,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
