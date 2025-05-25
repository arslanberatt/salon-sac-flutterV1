import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/core/user_session_controller.dart';
import 'package:mobil/core/user_info_controller.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';

class PasswordChangeScreen extends StatelessWidget {
  const PasswordChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<UserSessionController>();
    Future.delayed(Duration.zero, () {
      session.autoLogoutIfGuest();
    });
    final controller = Get.find<UserInfoController>();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    return Scaffold(
      backgroundColor: Color.fromARGB(249, 255, 255, 255),
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
                            CustomSnackBar.errorSnackBar(
                                title: "Hata", message: "Şifreler eşleşmiyor");
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
