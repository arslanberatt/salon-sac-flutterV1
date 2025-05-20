import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/user_info_controller.dart';
import 'package:mobil/screens/common/profile_edit_screen.dart';
import 'package:mobil/utils/constants/sizes.dart';
import 'package:mobil/utils/loaders/shimmer.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key, required this.userInfoController});

  final UserInfoController userInfoController;
  final String hello = "Merhaba,";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: ProjectSizes.IconM),
            Text(hello, style: Theme.of(context).textTheme.bodyLarge),
            Obx(() => userInfoController.loading.value
                ? const ShimmerEffect(width: 100, height: 20)
                : Text(
                    userInfoController.name.value.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w400),
                  )),
          ],
        ),
        GestureDetector(
          onTap: () => Get.to(ProfileEditScreen()),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              "assets/images/employee.png",
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
