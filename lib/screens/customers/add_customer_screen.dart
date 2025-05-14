import 'package:mobil/controllers/customers/add_customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddCustomerController());
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text("Müşteri Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(labelText: "Ad Soyad"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Ad boş olamaz";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.phoneController,
                decoration: const InputDecoration(labelText: "Telefon"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Telefon boş olamaz";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.notesController,
                decoration: const InputDecoration(labelText: "Notlar"),
              ),
              const SizedBox(height: 20),
              Obx(() => controller.isSaving.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.addCustomer();
                        }
                      },
                      child: const Text("Kaydet"),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
