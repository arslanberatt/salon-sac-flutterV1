import 'package:flutter/material.dart';
import 'package:mobil/utils/constants/sizes.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final double width;
  final BoxDecoration decoration;
  final Color cardTextColor;
  final Function()? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.decoration,
    this.width = 200,
    required this.cardTextColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ProjectSizes.md),
        ),
        elevation: 2,
        child: Container(
          height: 120,
          width: width - ProjectSizes.s,
          decoration: decoration,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 30, color: cardTextColor),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: cardTextColor, fontWeight: FontWeight.w600),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 14, color: cardTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
