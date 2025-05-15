import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoaderAdvance extends StatelessWidget {
  const LoaderAdvance({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        "assets/animations/money.json",
        height: 300,
        width: 300,
      ),
    );
  }
}
