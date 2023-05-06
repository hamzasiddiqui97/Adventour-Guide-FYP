import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';

class RoundBackButton extends StatelessWidget {
  Color color;
  double size;
  Color iconColor;
  RoundBackButton({
    this.color = ColorPalette.secondaryColor,
    this.size = 14,
    this.iconColor = ColorPalette.primaryColor,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Get.back();
        },
        child: Container(
          height: 15,
          width: 24,
          // padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black12,
            size: 24,
          ),
        )
    );
  }
}