import 'package:flutter/material.dart';

class CustomElevatedButtonTheme {
  static final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    elevation: 0,
    backgroundColor: const Color.fromRGBO(30, 142, 186, 1),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: Color.fromRGBO(30, 142, 186, 1),
        )),
  ));
}
