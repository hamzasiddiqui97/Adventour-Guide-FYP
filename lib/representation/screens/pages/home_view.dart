import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/widgets/search_bar_widget.dart';

class HomePageNavBar extends StatelessWidget {
  const HomePageNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
              Container(
                width: screenWidth,
                height: screenHeight*0.5,
                child: Text('Container 1'),color: Colors.amber,),
            ],)
          ],
        ),
      ),
    );
  }
}
