import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/user_info_controller.dart';
import 'package:mobil/screens/common/password_change_screen.dart';
import 'package:mobil/screens/common/profile_edit_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserInfoController());
    controller.fetchUserInfo();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlar"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 👤 Kullanıcı Bilgisi Kartı
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/employee.png"),
                    radius: 32,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.name.value,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text("Rol: ${controller.role.value}"),
                        Text("Email: ${controller.email.value}"),
                        Text("Telefon: ${controller.phone.value}"),
                        Text("Kayıt: ${controller.createdAt.value}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ⚙️ Ayarlar Seçenekleri
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Profil Bilgilerini Güncelle"),
              onTap: () {
                Get.to(() => const ProfileEditScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text("Şifreyi Değiştir"),
              onTap: () {
                Get.to(() => const PasswordChangeScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: const Text("Sürüm Notları"),
              subtitle: const Text("Yenilikleri keşfet"),
              onTap: () {
                Get.defaultDialog(
                  title: "Sürüm Notları",
                  content: const Text(
                    "- Yeni randevu ekranı\n- Hata düzeltmeleri\n- Performans iyileştirmeleri",
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text("İletişim"),
              subtitle: const Text("Bize ulaşın"),
              onTap: () {
                Get.snackbar("İletişim", "Destek e-posta: destek@ornek.com");
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text("Gizlilik ve Kullanım Koşulları"),
              onTap: () {
                Get.toNamed("/privacy");
              },
            ),

            const SizedBox(height: 32),
            Center(
              child: TextButton.icon(
                onPressed: () => Get.offAllNamed("/login"),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text("Çıkış Yap",
                    style: TextStyle(color: Colors.red)),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
                child: Text("Sürüm: v1.0.0",
                    style: TextStyle(color: Colors.grey))),
          ],
        );
      }),
    );
  }
}
