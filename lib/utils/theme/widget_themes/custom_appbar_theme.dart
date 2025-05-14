import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomAppbarThemes {
  static const appBarTheme = AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(size: 24),
    actionsIconTheme: IconThemeData(size: 24),
    titleSpacing: 0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.w800,
    ),
  );
}
