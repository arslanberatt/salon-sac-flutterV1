import 'package:flutter/material.dart';
import 'package:mobil/utils/constants/sizes.dart';
import 'package:mobil/utils/loaders/shimmer.dart';

class ListTileShimmer extends StatelessWidget {
  const ListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Column(
          children: [
            ShimmerEffect(width: double.infinity, height: 15),
            SizedBox(height: ProjectSizes.spaceBtwItems / 2),
            ShimmerEffect(width: double.infinity, height: 15),
            SizedBox(height: ProjectSizes.spaceBtwItems / 2),
            ShimmerEffect(width: double.infinity, height: 15),
            SizedBox(height: ProjectSizes.spaceBtwItems / 2),
            ShimmerEffect(width: double.infinity, height: 12)
          ],
        )
      ],
    );
  }
}
