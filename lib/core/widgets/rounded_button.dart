import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  String name;
  VoidCallback? onPress;
  Color color;
  double? width;
  Color? textColor;
  double? fontSize;

  RoundedButton({required this.name,this.textColor,this.onPress, this.fontSize,required this.color,this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onPress,
        child: Container(
          width: width,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(child: Text(name, style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
          )
          ),
        ),
      ),
    );
  }
}