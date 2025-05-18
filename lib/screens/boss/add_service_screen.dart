import 'package:mobil/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/add_service_controller.dart';

class AddServiceScreen extends StatelessWidget {
  const AddServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddServiceController());

    return Scaffold(
      appBar: AppBar(title: const Text("Hizmet Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: controller.titleController,
              decoration: const InputDecoration(labelText: "Başlık"),
            ),
            SizedBox(
              height: ProjectSizes.spaceBtwItems,
            ),
            TextFormField(
              controller: controller.durationController,
              decoration: const InputDecoration(labelText: "Süre (dk)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: ProjectSizes.spaceBtwItems,
            ),
            TextFormField(
              controller: controller.priceController,
              decoration: const InputDecoration(labelText: "Ücret (₺)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: ProjectSizes.spaceBtwItems * 2,
            ),
            Obx(() => controller.isSaving.value
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.submit,
                      child: Text(
                        "Kaydet",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
