import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/view/screens/pages/main_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // Use a future to delay the navigation to the home screen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 550,
              width: 490,
              // height: double.infinity,
              // width: double.infinity,
              child: Image.asset('assets/images/splash_screen.png',
              fit: BoxFit.cover,)
              ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
