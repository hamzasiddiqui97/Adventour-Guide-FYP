import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/widgets/bookingPopup.dart';

class Prompts {
  static bookNow(String hotelOwnerUID, bool isTransport) {
    Get.dialog(
       BookNow( hotelOwnerUID: hotelOwnerUID, isTransport: isTransport,),
      barrierColor: Colors.grey.withOpacity(
        0.8,
      ),
    );
  }}