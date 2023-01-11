import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final TextStyle style;
  HeadingText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}