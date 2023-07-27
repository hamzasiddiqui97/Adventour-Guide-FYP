import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';

import '../../../widgets/heading_text.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          color: Colors.white,
          width: screenWidth,
          // height: screenHeight,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: HeadingText(
                        text: "Welcome to",
                        style: TextStyle(fontSize: 30, color: Colors.black)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: HeadingText(
                        text: "Adventour & Guide",
                        style: TextStyle(fontSize: 30, color: Colors.black)),
                  ),
                ],
              ),
            ),
            Container(
              height: screenHeight / 1.7,
              width: screenWidth,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/splash_screen.png"),
                      fit: BoxFit.cover)),
            ),
            Ink(
              color: Colors.grey,
              child: IconButton
                (
                  onPressed: () {

                    Navigator.pushReplacementNamed(context, '/signIn');
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 50,
                    color: ColorPalette.secondaryColor,
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
