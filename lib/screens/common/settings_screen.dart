import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlar"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 👤 Profil Güncelleme
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage:
                    AssetImage("assets/images/profile.png"), // Profil resmi
                radius: 28,
              ),
              title: const Text("Profil Bilgilerim",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Bilgilerini düzenle"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.toNamed("/profile-edit");
              },
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),

          // 📄 Sürüm Notları
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text("Sürüm Notları"),
            subtitle: const Text("Yenilikleri keşfet"),
            onTap: () {
              // örnek dialog veya sayfa
              Get.defaultDialog(
                title: "Sürüm Notları",
                content: const Text(
                    "- Yeni randevu ekranı\n- Hata düzeltmeleri\n- Performans iyileştirmeleri"),
              );
            },
          ),

          // 📞 İletişim
          ListTile(
            leading: const Icon(Icons.support_agent),
            title: const Text("İletişim"),
            subtitle: const Text("Bize ulaşın"),
            onTap: () {
              // Mail uygulaması açılabilir
              Get.snackbar("İletişim", "Destek e-posta: destek@ornek.com");
            },
          ),

          // 📜 Gizlilik ve Kullanım Koşulları
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text("Gizlilik ve Kullanım Koşulları"),
            subtitle: const Text("Yasal bilgiler"),
            onTap: () {
              // WebView sayfası ya da iç sayfa açılabilir
              Get.toNamed("/privacy");
            },
          ),

          const SizedBox(height: 32),

          // 🚪 Çıkış Yap
          Center(
            child: TextButton.icon(
              onPressed: () {
                // Çıkış işlemi
                Get.offAllNamed("/login");
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label:
                  const Text("Çıkış Yap", style: TextStyle(color: Colors.red)),
            ),
          ),

          const SizedBox(height: 16),
          const Center(
              child:
                  Text("Sürüm: v1.0.0", style: TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }
}
