import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyTextField extends StatelessWidget {
  Color color; Color? hintColor; Color? fontColor; Color borderColor; Color? suffixIconColor;
  String hint; IconData? suffixIcon; TextEditingController? controller; Widget? icon; bool obscureText;
  FontWeight? fontWeight; double? radius; double size; double height; double? width; final onChanged;
  int maxLines; VoidCallback? onSuffixIconTap; bool enabled; double? suffixIconSize;
  final keyboardType; final onEditingComplete; Widget? mySuffixIcon;final validator; EdgeInsetsGeometry? contentPadding;
  MyTextField({
    Key? key, this.onChanged,
    this.hint = 'Type something..',
    this.radius,
    this.fontColor = ColorPalette.textColor,
    this.mySuffixIcon,
    this.size = 12, this.keyboardType,
    this.controller, this.suffixIconColor,
    this.suffixIcon, this.enabled = true,
    this.icon, this.obscureText = false,
    this.height = 50, this.onSuffixIconTap,
    this.hintColor, this.suffixIconSize,
    this.fontWeight, this.onEditingComplete,
    this.maxLines = 1,
    this.color = Colors.transparent,
    this.width, this.borderColor = Colors.transparent,
    this.validator,
    this.contentPadding

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        // padding: EdgeInsets.symmetric(horizontal: 15.w),
        // width: width == null? Get.width : Get.width/(375/width!), height: Get.height/(812/height),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: borderColor,
                width: 1
            )
        ),
        child: Center(
          child:
          TextFormField(
            cursorColor: ColorPalette.secondaryColor,
            validator: validator,
            onEditingComplete: onEditingComplete,
            keyboardType: keyboardType,
            onChanged: onChanged,
            controller: controller,
            maxLines: maxLines,
            obscureText: obscureText,
            enabled: enabled,
            decoration: InputDecoration(
                contentPadding: contentPadding,
                border: InputBorder.none,
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(20),
                // ),
                hintText: hint,
                icon: icon,
                suffixIcon: mySuffixIcon != null?
                GestureDetector(
                  onTap: onSuffixIconTap,
                  child: mySuffixIcon,
                ): GestureDetector(
                  onTap: onSuffixIconTap,
                  child: Icon(suffixIcon, size: suffixIconSize, color: suffixIconColor),
                ),
                // hintStyle: GoogleFonts.poppins(
                //   color: hintColor,
                //   fontSize: size.sp,
                //   fontWeight: fontWeight,
                // )
            ),
          ),
        ),
      );
  }
}