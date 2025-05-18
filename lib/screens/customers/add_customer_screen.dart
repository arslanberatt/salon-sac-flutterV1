import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/customers/add_customer_controller.dart';
import 'package:mobil/utils/constants/sizes.dart';

class AddCustomerScreen extends StatelessWidget {
  AddCustomerScreen({super.key});
  final customerController = Get.put(AddCustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Müşteri Ekle",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Domine',
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
                maxLines: 2,
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
