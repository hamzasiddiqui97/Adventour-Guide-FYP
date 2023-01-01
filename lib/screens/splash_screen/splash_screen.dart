import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [

          Positioned(
            height: height*.6,
            bottom: 40,
              right: 30,
              child: Container(

              )
          ),
        ],
      ),
    );
  }
}
