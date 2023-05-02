import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';

class CustomInfoWindow extends StatefulWidget {
  final String title;
  final String distance;
  final String duration;
  final String nextPlaceName;

  const CustomInfoWindow({
    Key? key,
    required this.title,
    required this.distance,
    required this.duration,
    required this.nextPlaceName,
  }) : super(key: key);

  @override
  _CustomInfoWindowState createState() => _CustomInfoWindowState();
}

class _CustomInfoWindowState extends State<CustomInfoWindow> {
  TextStyle highlightText = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: ColorPalette.secondaryColor,
  );
  TextStyle headingStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.black,
  );
  TextStyle normalText = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    bool isDestination = widget.nextPlaceName == 'Destination';

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              children: [
                if (!isDestination)
                  Text(
                    '${widget.duration} and ${widget.distance}',
                    style: highlightText,
                  ),
                const SizedBox(height: 8),
                Text(
                  isDestination
                      ? 'This is your destination'
                      : 'to next stop ${widget.nextPlaceName}',
                  style: normalText,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
