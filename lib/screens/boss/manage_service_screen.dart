import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobil/core/services/add_service_controller.dart';
import 'package:mobil/core/services/service_controller.dart';
import 'package:mobil/utils/constants/colors.dart';
import 'package:mobil/utils/constants/sizes.dart';
import 'package:mobil/utils/loaders/loader_service.dart';

class ManageServicesScreen extends StatelessWidget {
  ManageServicesScreen({super.key});
  final serviceController = Get.put(ServiceController());
  final addServiceController = Get.put(AddServiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hizmet Ekle",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: ProjectSizes.spaceBtwItems),
                  TextFormField(
                    controller: addServiceController.titleController,
                    decoration: const InputDecoration(labelText: "Başlık"),
                  ),
                  const SizedBox(height: ProjectSizes.spaceBtwItems),
                  TextFormField(
                    controller: addServiceController.durationController,
                    decoration: const InputDecoration(labelText: "Süre (dk)"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: ProjectSizes.spaceBtwItems),
                  TextFormField(
                    controller: addServiceController.priceController,
                    decoration: const InputDecoration(labelText: "Ücret (₺)"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: ProjectSizes.spaceBtwItems * 2),
                  addServiceController.isSaving.value
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: addServiceController.submit,
                            child: const Text("Kaydet"),
                          ),
                        ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("Tüm Hizmetler",
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: ProjectSizes.spaceBtwItems),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: serviceController.loading.value
                    ? const Center(child: LoaderService())
                    : serviceController.services.isEmpty
                        ? const Center(child: Text("Henüz hizmet eklenmedi."))
                        : ListView.builder(
                            itemCount: serviceController.services.length,
                            itemBuilder: (context, index) {
                              final service = serviceController.services[index];
                              return ListTile(
                                leading: Icon(Iconsax.card_tick4),
                                title: Text(service['title']),
                                subtitle: Text(
                                    "Süre: ${service['duration']} dk\n₺${service['price']}"),
                              );
                            },
                          ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
