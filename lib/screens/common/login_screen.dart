import 'package:mobil/core/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/utils/constants/sizes.dart';

class LoginScreen extends StatelessWidget {
  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: ProjectSizes.containerPaddingM),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          "assets/images/logo.jpg",
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: ProjectSizes.s),
                    const Text(
                      "SALON SAÇ",
                      style: TextStyle(
                        fontSize: ProjectSizes.containerPaddingL,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Domine',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: ProjectSizes.containerPaddingXL),
              Text("Giriş Yap", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: ProjectSizes.containerPaddingM),
              TextField(
                decoration: const InputDecoration(labelText: "Email"),
                onChanged: (val) => controller.email.value = val,
              ),
              const SizedBox(height: ProjectSizes.containerPaddingS),
              TextField(
                decoration: const InputDecoration(labelText: "Parola"),
                obscureText: true,
                onChanged: (val) => controller.password.value = val,
              ),
              const SizedBox(height: 20),
              controller.loading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.login,
                        child: Text(
                          "Giriş Yap",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: ProjectSizes.containerPaddingM / 1.5,
                              ),
                        ),
                      ),
                    ),
              const SizedBox(height: ProjectSizes.containerPaddingS),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Hesabınız yok mu?"),
                  TextButton(
                    onPressed: () {
                      // TODO: Login sayfasına git
                    },
                    child: const Text("Kayıt Ol",
                        style: TextStyle(
                          color: Colors.blue,
                        )),
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



// Column(
//               children: [
//                 TextField(
//                   decoration: const InputDecoration(labelText: "Email"),
//                   onChanged: (val) => controller.email.value = val,
//                 ),
//                 TextField(
//                   decoration: const InputDecoration(labelText: "Şifre"),
//                   obscureText: true,
//                   onChanged: (val) => controller.password.value = val,
//                 ),
//                 const SizedBox(height: 20),
//                 controller.loading.value
//                     ? const CircularProgressIndicator()
//                     : ElevatedButton(
//                         onPressed: controller.login,
//                         child: const Text("Giriş Yap"),
//                       ),
//               ],
//             ),