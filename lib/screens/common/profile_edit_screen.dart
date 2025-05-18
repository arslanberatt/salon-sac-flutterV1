import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/user_info_controller.dart';
import 'package:mobil/utils/constants/sizes.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserInfoController>();
    final nameController = TextEditingController(text: controller.name.value);
    final phoneController = TextEditingController(text: controller.phone.value);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profil Bilgileri",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Domine',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Profil Güncelle",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: ProjectSizes.spaceBtwItems),
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
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isUpdating.value
                        ? null
                        : () async {
                            await controller.updateMyInfo(
                              newName: nameController.text.trim(),
                              newPhone: phoneController.text.trim(),
                            );
                          },
                    child: controller.isUpdating.value
                        ? const CircularProgressIndicator()
                        : const Text("Güncelle"),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
