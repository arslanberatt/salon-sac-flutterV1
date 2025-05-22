import 'package:flutter/material.dart';

class BossAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BossAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 90,
      backgroundColor: Colors.white,
      elevation: 4,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      flexibleSpace: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage("assets/images/logo.jpg"),
                ),
              ),
              Center(
                child: Text(
                  "SALON SAÇ",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontFamily: 'Teko',
                    color: Colors.black87,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 52,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
