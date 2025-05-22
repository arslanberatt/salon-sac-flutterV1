import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/core/user_session_controller.dart';
import 'package:mobil/core/customers/add_customer_controller.dart';
import 'package:mobil/utils/constants/sizes.dart';

class AddCustomerScreen extends StatelessWidget {
  AddCustomerScreen({super.key});
  final customerController = Get.put(AddCustomerController());

  @override
  Widget build(BuildContext context) {
    final session = Get.find<UserSessionController>();
    Future.delayed(Duration.zero, () {
      session.autoLogoutIfGuest();
    });
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
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Yeni Müşteri",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: ProjectSizes.spaceBtwItems),
              TextFormField(
                controller: customerController.nameController,
                decoration: const InputDecoration(labelText: "Ad Soyad"),
              ),
              const SizedBox(height: ProjectSizes.spaceBtwItems),
              TextFormField(
                controller: customerController.phoneController,
                decoration: const InputDecoration(labelText: "Telefon"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: ProjectSizes.spaceBtwItems),
              TextFormField(
                controller: customerController.notesController,
                decoration: const InputDecoration(labelText: "Not (opsiyonel)"),
              ),
              const SizedBox(height: ProjectSizes.spaceBtwItems),
              customerController.isSaving.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      height: ProjectSizes.containerPaddingXL,
                      child: ElevatedButton(
                        onPressed: customerController.addCustomer,
                        child: const Text("Müşteri Ekle"),
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }
}
