import 'package:flutter/material.dart';
import 'package:mobil/utils/constants/sizes.dart';

class CustomTextFieldTheme {
  CustomTextFieldTheme._();

  static InputDecorationTheme lightTextFieldTheme = InputDecorationTheme(
    filled: true,
    fillColor: Color.fromRGBO(243, 244, 246, 1),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ProjectSizes.s),
      borderSide: const BorderSide(color: Color.fromRGBO(238, 239, 242, 1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ProjectSizes.s),
      borderSide:
          const BorderSide(color: Color.fromRGBO(30, 142, 186, 1), width: 1.8),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ProjectSizes.s),
      borderSide: const BorderSide(color: Color.fromRGBO(238, 239, 242, 1)),
    ),
    labelStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    hintStyle: const TextStyle(
      color: Colors.grey,
    ),
  );
}
