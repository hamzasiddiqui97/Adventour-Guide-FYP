import 'package:flutter/material.dart';
class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar (String? text,bool? success) {
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text),backgroundColor: success==true?Colors.green:Colors.red,);

    messengerKey.currentState!..removeCurrentSnackBar()..showSnackBar(snackBar);
  }
}