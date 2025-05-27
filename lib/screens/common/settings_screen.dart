import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/core/user_session_controller.dart';
import 'package:mobil/core/user_info_controller.dart';
import 'package:mobil/screens/boss/home/widgets/boss_app_bar.dart';
import 'package:mobil/screens/common/password_change_screen.dart';
import 'package:mobil/screens/common/privacy_policy_screen.dart';
import 'package:mobil/screens/common/profile_edit_screen.dart';
import 'package:mobil/utils/constants/colors.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  static const String surumNotu = "- Şuan ilk sürümü kullanıyorsunuz.\n";

  @override
  Widget build(BuildContext context) {
    final session = Get.find<UserSessionController>();
    Future.delayed(Duration.zero, () {
      session.autoLogoutIfGuest();
    });
    final controller = Get.put(UserInfoController());
    controller.fetchUserInfo();

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: BossAppBar(),
      ),
      body: Obx(() {
        return ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/employee.png"),
                    radius: 30,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.name.value,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("Email: ${controller.email.value}"),
                        Text("Telefon: ${controller.phone.value}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            _buildItem(Icons.person_outline, "Profil Bilgilerini Güncelle", () {
              Get.to(() => const ProfileEditScreen());
            }),
            _buildDivider(),

            _buildItem(Icons.lock_outline, "Şifreyi Değiştir", () {
              Get.to(() => const PasswordChangeScreen());
            }),
            _buildDivider(),

            _buildItem(Icons.article_outlined, "Sürüm Notları", () {
              Get.defaultDialog(
                backgroundColor: Colors.white,
                titleStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                radius: 10,
                titlePadding: const EdgeInsets.only(top: 16),
                title: "Sürüm Notları",
                content: const Text(
                  surumNotu,
                ),
              );
            }),
            _buildDivider(),

            _buildItem(
              Icons.support_agent,
              "İletişim",
              () {
                CustomSnackBar.warningSnackBar(
                    title: "İletişim",
                    message: "İletişim için: arslanberattdev@gmail.com",
                    duration: 5);
              },
            ),
            _buildDivider(),

            _buildItem(
                Icons.privacy_tip_outlined, "Gizlilik ve Kullanım Koşulları",
                () {
              Get.to(() => const PrivacyPolicyScreen());
            }),
            _buildDivider(),

            // 🚪 Çıkış
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Çıkış Yap",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => Get.find<UserSessionController>().logoutUser(),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDivider() => const Divider(
        height: 1,
        thickness: 0.6,
        endIndent: 40,
        indent: 40,
      );
}
