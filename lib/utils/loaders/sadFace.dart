import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SadFace extends StatelessWidget {
  const SadFace({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        "assets/animations/sadFace.json",
        height: 200,
        width: 200,
      ),
    );
  }
}
