import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';

class SearchBar extends StatelessWidget {

  VoidCallback? onPress;
  String? hintText;
  Icon? icon;
  double? width;

  SearchBar({
    this.onPress,
    this.icon,
    this.hintText,
    this.width,
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
        onTap: onPress,
        // onChanged: (){},
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: ColorPalette.searchBarColor,
          ),
          hintText: "Search Places",
          border: InputBorder.none,
        ),

      ),
    );
  }
}
