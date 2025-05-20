import 'package:flutter/material.dart';

class BossAppBar extends StatelessWidget {
  const BossAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.grey[100],
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            "assets/images/logo.jpg",
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: const Text(
        "SALON SAÇ",
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Domine'),
      ),
    );
  }
}
