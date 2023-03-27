import 'package:flutter/material.dart';

import '../../../core/constant/color_constants.dart';
class MyPlan extends StatelessWidget {
  const MyPlan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: ColorPalette.secondaryColor,
          foregroundColor: ColorPalette.primaryColor,
          title: const Text('My Trips'),
          centerTitle: true,
        ),
        body: Container(
            child: const Center(child: Text('No trips to show'),),
        )
      ),
    );
  }
}
