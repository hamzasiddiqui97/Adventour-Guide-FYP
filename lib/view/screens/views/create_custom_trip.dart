import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';

class CreateCustomTrip extends StatelessWidget {
  const CreateCustomTrip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Create Trip"),
            centerTitle: true,
            foregroundColor: ColorPalette.primaryColor,
            backgroundColor: ColorPalette.secondaryColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // TextFormField(
                //   decoration: InputDecoration(icon: Icon(Icons.add)),
                // ),
              ],
            ),
          ),
        )
    );
  }
}
