import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
          height: 6.h,
          width: 15.w,
          // padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
            size: 24,
          ),
        )
    );
  }
}