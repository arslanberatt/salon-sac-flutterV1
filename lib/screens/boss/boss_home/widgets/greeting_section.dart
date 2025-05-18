import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/controllers/core/user_session_controller.dart';
import 'package:mobil/core/user_info_controller.dart';
import 'package:mobil/screens/customers/add_customer_screen.dart';
import 'package:mobil/utils/constants/sizes.dart';

class GreetingSection extends StatelessWidget {
  GreetingSection({super.key});

  final String hello = "Merhaba,";

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserInfoController());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: ProjectSizes.IconM),
            Text(hello, style: Theme.of(context).textTheme.headlineSmall),
            Obx(() => Text(
                  controller.name.value,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
                )),
          ],
        ),
        GestureDetector(
          onTap: () => Get.to(AddCustomerScreen()),
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
