import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  // Color containerColor;
  // double borderRadius;
  // int containerHeight;
  // String hintText;
  // Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: ColorPalette.primaryColor,
          borderRadius: BorderRadius.circular(6)),
      child: const TextField(
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
