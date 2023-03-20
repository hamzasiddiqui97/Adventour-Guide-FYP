import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';

class SearchBar extends StatelessWidget {

  VoidCallback? onPress;
  String? hintText;
  Icon? icon;
  double? width;
  IconButton? suffixIcon;
  TextEditingController? controller;
  VoidCallback? onValueSubmitted;


  SearchBar({
    this.onPress,
    this.icon,
    this.hintText,
    this.width,
    this.suffixIcon,
    this.controller,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
          color: ColorPalette.primaryColor,
          borderRadius: BorderRadius.circular(6)),
      child: TextField(
        onSubmitted: (value) {
          onValueSubmitted;
        },
        controller: controller,
        onTap: onPress,
        // onChanged: (){},
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorPalette.secondaryColor)),
          suffixIcon: suffixIcon,
          prefixIcon: Icon(
            Icons.search,
            color: ColorPalette.searchBarColor,
            size: 28,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),

      ),
    );
  }
}