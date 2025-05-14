import 'package:mobil/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CheckInCard extends StatelessWidget {
  final String title;
  final String customer;
  final String checkIn;
  final String checkOut;
  final String duration;

  const CheckInCard({
    super.key,
    required this.title,
    required this.customer,
    required this.checkIn,
    required this.checkOut,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    String firstTime = "Tahmini Giriş";
    String lastTime = "Tahmini Çıkış";
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 239, 242, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.timer,
                          size: 14, color: Colors.lightBlue),
                      const SizedBox(width: 4),
                      Text(duration,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: ProjectSizes.xs),
            Text(customer,
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(firstTime, style: TextStyle(color: Colors.grey)),
                Icon(Iconsax.arrow_swap_horizontal, color: Colors.grey),
                Text(lastTime, style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: ProjectSizes.s),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(checkIn,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                Text(checkOut,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
