import 'package:flutter/material.dart';

class ProjectColors {
  //Neutral Colors
  static const Color whiteColor = Colors.white;
  static const Color gray4Color = Color(0xffE0E0E0);
  static const Color gray3Color = Color(0xff999999);
  static const Color gray2Color = Color(0xff666666);
  static const Color grayColor = Color(0xff333333);
  static const Color neutralBlackColor = Color(0xff151522);

  //--------------------------------------------------------------------------//

  //Primary Colors

  //Button mavisi
  static const Color mainColor = Color.fromRGBO(71, 172, 211, 1);
  static const Color main2Color = Color.fromRGBO(30, 142, 186, 1);
  static const Color main3Color = Color.fromRGBO(75, 135, 180, 1);

  //Background renkleri
  static const Color backColor = Color.fromARGB(228, 253, 250, 250);
  static const Color back1Color = Color.fromRGBO(245, 246, 246, 1);
  //Red
  static const Color red3Color = Color(0xffFFCBD3);
  static const Color red2Color = Color(0xffFF98A8);
  static const Color redColor = Color(0xffFF647C);

  //Purple
  static const Color purple3Color = Color(0xffCDD2FD);
  static const Color purple2Color = Color(0xff9BA6FA);
  static const Color purpleColor = Color(0xff6979F8);

  //Orange
  static const Color orange3Color = Color(0xffFBDDC3);
  static const Color orange2Color = Color(0xffF6BB86);
  static const Color orangeColor = Color(0xffF2994A);

  //Green
  static const Color green3Color = Color(0xff96FFE1);
  static const Color green2Color = Color(0xff2EFFC3);
  static const Color greenColor = Color(0xff00C48C);

  //--------------------------------------------------------------------------//

  //Finance Colors
  static const Color finance3Color = Color(0xff3D639D);
  static const Color finance2Color = Color.fromARGB(178, 61, 99, 157);
  static const Color financeColor = Color(0xff343D63);

  //--------------------------------------------------------------------------//

  // Gradients
  static const Gradient blackGradient = LinearGradient(colors: <Color>[
    ProjectColors.neutralBlackColor,
    ProjectColors.gray2Color
  ]);
  static const Gradient blackVerticalGradient = LinearGradient(
    colors: <Color>[ProjectColors.neutralBlackColor, ProjectColors.gray2Color],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  static const Gradient backGradient = LinearGradient(
    colors: <Color>[ProjectColors.backColor, ProjectColors.back1Color],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Gradient blueGradient = LinearGradient(
    colors: <Color>[ProjectColors.mainColor, ProjectColors.main2Color],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Gradient redGradient = LinearGradient(
    colors: <Color>[ProjectColors.redColor, ProjectColors.red2Color],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient purpleGradient = LinearGradient(
    colors: <Color>[ProjectColors.purpleColor, ProjectColors.purple2Color],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient orangeGradient = LinearGradient(
    colors: <Color>[ProjectColors.orangeColor, ProjectColors.orange2Color],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient greenGradient = LinearGradient(
    colors: <Color>[ProjectColors.greenColor, ProjectColors.green2Color],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient financeGradient = LinearGradient(
    colors: <Color>[ProjectColors.financeColor, ProjectColors.finance2Color],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
