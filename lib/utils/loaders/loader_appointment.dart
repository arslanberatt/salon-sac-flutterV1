import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoaderAppointment extends StatelessWidget {
  const LoaderAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        "assets/animations/appointment.json",
        height: 200,
        width: 200,
      ),
    );
  }
}
