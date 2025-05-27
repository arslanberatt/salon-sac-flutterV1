import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/auth/auth_controller.dart';
import 'package:mobil/utils/constants/sizes.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kayıt Ol"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        "assets/images/logo.jpg",
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "SALON SAÇ",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Teko',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              /// Ad
              TextField(
                decoration: const InputDecoration(labelText: "Ad"),
                onChanged: (val) => controller.firstName.value = val,
              ),
              const SizedBox(height: ProjectSizes.containerPaddingS),

              /// Soyad
              TextField(
                decoration: const InputDecoration(labelText: "Soyad"),
                onChanged: (val) => controller.lastName.value = val,
              ),
              const SizedBox(height: ProjectSizes.containerPaddingS),

              /// Telefon
              TextField(
                decoration: const InputDecoration(
                  labelText: "Telefon",
                  prefixText: "+90 ",
                  hintText: "5XXXXXXXXX",
                ),
                keyboardType: TextInputType.phone,
                maxLength: 10, // sadece 10 rakam alınacak
                onChanged: (val) {
                  // sadece rakamları al, diğer karakterleri sil
                  controller.phone.value = val.replaceAll(RegExp(r'\D'), '');
                },
              ),

              const SizedBox(height: ProjectSizes.containerPaddingS),

              /// Email
              TextField(
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) => controller.email.value = val,
              ),
              const SizedBox(height: ProjectSizes.containerPaddingS),

              /// Parola
              TextField(
                decoration: const InputDecoration(labelText: "Parola"),
                obscureText: true,
                onChanged: (val) => controller.password.value = val,
              ),
              const SizedBox(height: ProjectSizes.containerPaddingS),

              /// Parola Tekrar
              TextField(
                decoration: const InputDecoration(labelText: "Parola Tekrar"),
                obscureText: true,
                onChanged: (val) => controller.confirmPassword.value = val,
              ),
              const SizedBox(height: 24),

              /// Kayıt Butonu
              Obx(() => controller.loading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.register,
                        child: const Text("Kayıt Ol"),
                      ),
                    )),

              const SizedBox(height: 16),

              /// Girişe Dön
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Zaten hesabın var mı?"),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Giriş Yap"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
