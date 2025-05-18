import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/user_info_controller.dart';

class PasswordChangeScreen extends StatelessWidget {
  const PasswordChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserInfoController>();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Şifreyi Değiştir")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Yeni Şifre"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: "Yeni Şifre (Tekrar)"),
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
                  onPressed: controller.isUpdating.value
                      ? null
                      : () async {
                          if (passwordController.text !=
                              confirmController.text) {
                            Get.snackbar("Hata", "Şifreler eşleşmiyor");
                            return;
                          }
                          await controller.updateMyInfo(
                            newPassword: passwordController.text.trim(),
                          );
                          Get.back();
                        },
                  child: controller.isUpdating.value
                      ? const CircularProgressIndicator()
                      : const Text("Şifreyi Güncelle"),
                )),
          ],
        ),
      ),
    );
  }
}
