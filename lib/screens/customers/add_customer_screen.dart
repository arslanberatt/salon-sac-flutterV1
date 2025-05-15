import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/controllers/customers/add_customer_controller.dart';

class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddCustomerController());
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Müşteri Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Ad Soyad
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: "Ad Soyad",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Ad boş olamaz";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// Telefon
              TextFormField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Telefon",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Telefon boş olamaz";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// Notlar
              TextFormField(
                controller: controller.notesController,
                decoration: const InputDecoration(
                  labelText: "Notlar (Opsiyonel)",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              /// Kaydet Butonu
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                      ),
                      onPressed: controller.isSaving.value
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await controller.addCustomer();
                                Get.snackbar("Başarılı", "Müşteri eklendi");
                              }
                            },
                      child: controller.isSaving.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Kaydet"),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
