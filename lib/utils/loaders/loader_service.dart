import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoaderService extends StatelessWidget {
  const LoaderService({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        "assets/animations/scissors.json",
        height: 100,
        width: 100,
      ),
    );
  }
}
