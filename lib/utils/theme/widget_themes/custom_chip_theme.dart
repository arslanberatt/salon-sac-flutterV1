import 'package:flutter/material.dart';

class CustomChipTheme {
  static ChipThemeData lightChipThemeData = ChipThemeData(
    disabledColor: Colors.white,
    backgroundColor: Colors.white,
    labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
    selectedColor: Colors.blue,
    padding: EdgeInsets.all(10),
    checkmarkColor: Colors.white,
  );
}
