import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:mobil/controllers/core/user_session_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  final storage = const FlutterSecureStorage();

  SplashScreen({super.key});

  Future<void> checkAuth() async {
    final token = await storage.read(key: "token");
    await Future.delayed(const Duration(seconds: 1)); // Splash efekti için

    if (token == null) {
      Get.offAllNamed('/login');
      return;
    }

    try {
      final parts = token.split('.');
      if (parts.length != 3) throw Exception('Geçersiz token');

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64.normalize(parts[1]))),
      );

      final role = payload["role"];
      final id = payload["id"];

      if (role == null || id == null) throw Exception("Eksik token bilgisi");

      // Oturumu güncelle
      final session = Get.find<UserSessionController>();
      session.setUser(
        userId: id,
        userName: "", // JWT'de name yoksa boş bırakıyoruz
        userRole: role,
      );

      print("🔁 Splash üzerinden oturum güncellendi:");
      session.printSessionInfo();

      if (role == "patron" || role == "calisan") {
        Get.offAllNamed('/main');
      } else {
        Get.snackbar("Onay Bekleniyor", "Hesabınız henüz onaylanmamış.");
        Get.offAllNamed('/login');
      }
    } catch (e) {
      print("❌ Splash parse hatası: $e");
      await storage.delete(key: "token");
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    checkAuth(); // Uygulama açıldığında tetiklenir

    return Scaffold(
      body: Center(
        child: Lottie.asset(
          "assets/animations/loading.json",
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
