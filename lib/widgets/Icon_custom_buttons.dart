import 'package:flutter/material.dart';

class IconButton extends StatelessWidget {

  IconData iconCustom;

  double? size;
  Color? color;

  IconButton({
    required this.iconCustom,
    this.size,
    this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Perform some action when the container is tapped
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.zero,
        ),
        child: Center(
          child: Icon(iconCustom,size: size,color: color,)
        ),
      ),
    );
  }
}