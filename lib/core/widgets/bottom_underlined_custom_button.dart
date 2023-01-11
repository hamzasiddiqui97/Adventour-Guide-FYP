import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';

class UnderlineButton extends StatelessWidget {

  String name;
  VoidCallback? onPress;
  Color color;
  double width;
  Color? textColor;
  double? fontSize;


  UnderlineButton({required this.name,this.textColor,this.onPress, this.fontSize,required this.color,required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onPress,
        child: Container(
          width: width,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            border: const Border(
              bottom: BorderSide(
                color: ColorPalette.secondaryColor,
                width: 2.0,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(child: Text(name, style: TextStyle(
                color: textColor,
                fontSize: fontSize,
              ),
              )
              ),
              InkWell(
                enableFeedback: true,
                splashColor: ColorPalette.secondaryColor,
                  child: Icon(Icons.arrow_forward_ios,color: ColorPalette.secondaryColor,)),
            ],
          ),
        ),
      ),
    );
  }
}