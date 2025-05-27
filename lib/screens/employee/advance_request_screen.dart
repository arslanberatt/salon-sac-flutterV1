import 'package:mobil/core/advance/controllers/advance_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/core/user_session_controller.dart';
import 'package:mobil/screens/boss/home/widgets/boss_app_bar.dart';
import 'package:mobil/utils/constants/colors.dart';
import 'package:mobil/utils/constants/sizes.dart';

class RequestAdvanceScreen extends StatelessWidget {
  const RequestAdvanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<UserSessionController>();
    Future.delayed(Duration.zero, () {
      session.autoLogoutIfGuest();
    });
    final controller = Get.put(RequestAdvanceController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
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
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Avans Talebi",
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: ProjectSizes.spaceBtwItems),
              TextField(
                controller: controller.amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Tutar (₺)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Açıklama (isteğe bağlı)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: ProjectSizes.containerPaddingXL,
                child: ElevatedButton.icon(
                  onPressed:
                      controller.isSaving.value ? null : controller.submit,
                  icon: const Icon(Icons.send),
                  label: controller.isSaving.value
                      ? const CircularProgressIndicator()
                      : const Text("Talep Gönder"),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
