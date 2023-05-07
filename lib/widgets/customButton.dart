import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class Button extends StatelessWidget {
  GestureTapCallback? onTap;
  double height;
  double width;
  String text;
  Color color;
  Color shadowColor;
  double size;
  FontWeight fontWeight;
  Color buttonColor;
  double radius;
  double horizontalPadding;
  Color borderColor;

  Button(
      {Key? key,
        required this.text,
        this.onTap,
        this.horizontalPadding = 0,
        this.radius = 30,
        this.color = Colors.black12,
        this.shadowColor = Colors.transparent,
        this.size = 14,
        this.fontWeight = FontWeight.w500,
        this.height = 50,
        this.buttonColor = ColorPalette.primaryColor,
        this.borderColor = ColorPalette.secondaryColor,
        this.width = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
        height: Get.height / (112 / height).h,
        width: Get.width / (375 / width).w,
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                  color: shadowColor, blurRadius: 10, offset: const Offset(0, 3))
            ]),
        child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: size,
                fontWeight: fontWeight,
              ),
            )),
      ),
    );
  }
}

class BackButtonText extends StatelessWidget {
  VoidCallback? onTap;
  String text;
  FontWeight fontWeight;
  Color color;
  Color iconColor;
  Color buttonColor;
  double size;
  BackButtonText({
    Key? key,
    this.onTap,
    required this.text,
    this.buttonColor = ColorPalette.secondaryColor,
    this.color = ColorPalette.secondaryColor,
    this.iconColor = ColorPalette.primaryColor,
    this.fontWeight = FontWeight.bold,
    this.size = 14
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyBackButton(
            onTap: onTap == null? ()=> Get.back() : onTap,
            color: buttonColor, iconColor: iconColor),
        SizedBox(width: 5.w),
        Text(text, style: TextStyle(fontWeight: fontWeight, color: color, fontSize: size,),),
      ],
    );
  }
}

class MyBackButton extends StatelessWidget {
  VoidCallback? onTap;
  Color color;
  double size;
  Color iconColor;
  MyBackButton({
    this.onTap,
    this.color = ColorPalette.secondaryColor,
    this.size = 14,
    this.iconColor = ColorPalette.primaryColor,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(
        onTap: onTap != null? onTap : ()=> Get.back(),
        child: Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: iconColor,
            size: size.sp,
          ),
        )
    );
  }
}