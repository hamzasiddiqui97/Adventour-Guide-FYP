import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/routes.dart';
import 'package:google_maps_basics/view/screens/pages/main_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adventour',
      theme: ThemeData(
        primaryColor: ColorPalette.primaryColor,
      ),
      routes: routes,
      debugShowCheckedModeBanner: false,
      // home: const CreateLatLongToAddress(),
      home: const NavigationPage(),
    );
  }
}
