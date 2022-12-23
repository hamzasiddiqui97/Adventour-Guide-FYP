import 'package:flutter/material.dart';
import 'package:google_maps_basics/search_places_api.dart';
import 'convert_lnglat_to_address.dart';
import 'home_screen.dart';
import 'pages/welcome/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const CreateLatLongToAddress(),
      home: const SearchPlacesAPIScreen(),
    );
  }
}
