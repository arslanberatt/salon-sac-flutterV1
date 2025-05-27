import 'package:mobil/utils/constants/colors.dart';
import 'package:mobil/utils/theme/widget_themes/custom_appbar_theme.dart';
import 'package:mobil/utils/theme/widget_themes/custom_chip_theme.dart';
import 'package:mobil/utils/theme/widget_themes/custom_elevated_button_theme.dart';
import 'package:mobil/utils/theme/widget_themes/text_field_theme.dart';
import 'package:flutter/material.dart';

class MyThemes {
  static final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.black,
      colorScheme: ColorScheme.light(
        primary: Colors.black,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: CustomAppbarThemes.appBarTheme,
      elevatedButtonTheme: CustomElevatedButtonTheme.elevatedButtonTheme,
      inputDecorationTheme: CustomTextFieldTheme.lightTextFieldTheme,
      fontFamily: "Poppins",
      chipTheme: CustomChipTheme.lightChipThemeData);
}
