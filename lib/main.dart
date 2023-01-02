import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/view/screens/pages/main_page.dart';
import 'package:google_maps_basics/view/screens/splash_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/splashScreen',
      routes: {
        '/splashScreen': (context) => SplashScreen(),
        '/home': (context) => const NavigationPage(),
      },
      title: 'Adventour',
      theme: ThemeData(
        primaryColor: ColorPalette.primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      // home: const CreateLatLongToAddress(),
      home: const NavigationPage(),
    );
  }
}
