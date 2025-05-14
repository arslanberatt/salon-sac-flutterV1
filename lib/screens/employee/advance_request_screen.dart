import 'package:mobil/controllers/advance/controllers/advance_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestAdvanceScreen extends StatelessWidget {
  const RequestAdvanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RequestAdvanceController());

    return Scaffold(
      appBar: AppBar(title: const Text("Avans Talebi")),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: controller.amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Tutar (₺)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Açıklama (isteğe bağlı)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      controller.isSaving.value ? null : controller.submit,
                  icon: const Icon(Icons.send),
                  label: controller.isSaving.value
                      ? const CircularProgressIndicator()
                      : const Text("Talep Gönder"),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
