import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';

class MyPlan extends StatelessWidget {
  const MyPlan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: const Text("My Trips"),
      //     centerTitle: true,
      // backgroundColor: ColorPalette.secondaryColor),
      body: const Center(child: Text('My Trips Screen')),
    );
  }
}
