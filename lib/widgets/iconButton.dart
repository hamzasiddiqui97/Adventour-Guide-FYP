import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class Iconbutton extends StatelessWidget {
  GestureTapCallback? onTap;
  Widget? MyIcon;
  double height;
  double? width;
  String text;
  Color color;
  Color iconColor;
  Color shadowColor;
  double size;
  double myIconsSize;
  FontWeight fontWeight;
  Color buttonColor;
  Color borderColor;
  double iconSize;
  double radius;
  IconData? icon;
  double padding;

  Iconbutton(
      {Key? key,
        required this.text,
        this.padding = 0,
        this.borderColor = Colors.transparent,
        this.myIconsSize = 15,
        this.onTap,
        this.MyIcon,
        this.color = Colors.black12,
        this.iconColor = Colors.black12,
        this.shadowColor = Colors.transparent,
        this.size = 14,
        this.fontWeight = FontWeight.w500,
        this.height = 50,
        this.buttonColor = ColorPalette.secondaryColor,
        this.icon,
        this.radius = 10,
        this.iconSize = 15,
        this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 5.h,
        width: width,
        // padding: EdgeInsets.symmetric(horizontal: padding.w),
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                  color: shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 3))
            ]),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyIcon == null
                  ? Container()
                  : SizedBox(
                height: 5.h,
                width: 5.w,
                child: MyIcon,
              ),
              icon == null
                  ? Container()
                  : Icon(icon, color: iconColor, size: iconSize.sp),
              SizedBox(
                width: 5.w,
              ),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: size,
                  fontWeight: fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}