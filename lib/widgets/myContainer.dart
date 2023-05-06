import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyContainer extends StatelessWidget {
  Widget? child; VoidCallback? onTap;
  double width; double? height;
  double topLeft; double topRight;
  double bottomLeft; double bottomRight;
  Color color; Color borderColor;
  double horizontalPadding;
  double verticalPadding;
  double horizontalMargin;
  double verticalMargin;
  double? radius;
  double borderWidth;
  BoxShape shape;
  Color shadowColor;
  List<Color>? gradientColors;
  MyContainer({
    Key? key,
    this.child, this.borderWidth = 1,
    this.bottomLeft = 0, this.bottomRight = 0,
    this.topLeft = 0, this.topRight = 0,
    this.radius, this.onTap,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.horizontalMargin = 0,
    this.verticalMargin = 0,
    this.shadowColor = Colors.transparent,
    this.width = double.infinity,
    this.height, this.gradientColors,
    this.shape = BoxShape.rectangle,
    this.color = Colors.transparent, this.borderColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w, vertical: verticalPadding.h),
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin.w, vertical: verticalMargin.h),
      width: Get.width/(375/width).w, height: height != null ? Get.height/(812/height!).h : height,
      decoration: BoxDecoration(
          color: color,
          borderRadius: radius == null?
          BorderRadius.only(
            topLeft: Radius.circular(topLeft.sp),
            topRight: Radius.circular(topRight.sp),
            bottomLeft: Radius.circular(bottomLeft.sp),
            bottomRight: Radius.circular(bottomRight.sp),
          )
              : BorderRadius.circular(radius!.sp),
          border: Border.all(
              color: borderColor,
              width: borderWidth
          ),
          shape: shape,
          boxShadow: [
            BoxShadow(
                color: shadowColor,
                blurRadius: 10,
                offset: Offset(0, 5)
            ),
          ]
      ),
      child: child,
    );
  }
}