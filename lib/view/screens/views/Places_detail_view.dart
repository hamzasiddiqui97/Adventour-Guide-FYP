import 'package:flutter/material.dart';

class PlacesDetail extends StatelessWidget {
  const PlacesDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: (){
            print("Button Pressed");
          },
          icon: Icon(Icons.arrow_back_ios),),
      ],
    );
  }
}
