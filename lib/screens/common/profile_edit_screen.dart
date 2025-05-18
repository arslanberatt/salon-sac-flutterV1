import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/user_info_controller.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserInfoController>();
    final nameController = TextEditingController(text: controller.name.value);
    final phoneController = TextEditingController(text: controller.phone.value);

    return Scaffold(
      appBar: AppBar(title: const Text("Profil Bilgilerini Güncelle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Ad Soyad"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Telefon"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
                  onPressed: controller.isUpdating.value
                      ? null
                      : () async {
                          await controller.updateMyInfo(
                            newName: nameController.text.trim(),
                            newPhone: phoneController.text.trim(),
                          );
                          Get.back(); // Geri dön
                        },
                  child: controller.isUpdating.value
                      ? const CircularProgressIndicator()
                      : const Text("Güncelle"),
                )),
          ],
        ),
      ),
    );
  }
}
