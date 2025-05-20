import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4),
          ],
        ),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
