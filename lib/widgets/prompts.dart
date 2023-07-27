import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/widgets/bookingPopup.dart';

class Prompts {
  static bookNow(String hotelOwnerUID) {
    Get.dialog(
       BookNow( hotelOwnerUID: hotelOwnerUID,),
      barrierColor: Colors.grey.withOpacity(
        0.8,
      ),
    );
  }}