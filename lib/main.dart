import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/representation/screens/pages/main_page.dart';
import 'package:google_maps_basics/routes.dart';
import 'package:google_maps_basics/search_places_api.dart';
import 'convert_lnglat_to_address.dart';

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
