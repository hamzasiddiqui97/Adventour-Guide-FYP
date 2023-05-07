import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class TopWithBackButton extends StatelessWidget {
  String? text;
  TopWithBackButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.only(left: 6.w, top: 4.h),
            height: 6.5.h,
            width: 12.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ColorPalette.secondaryColor,
            ),
            child: const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black12,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 5.w,
        ),
        Padding(
          padding: EdgeInsets.only(top: 3.5.h),
          child: Text(
            text!,
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: "PoppinsBold",
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}