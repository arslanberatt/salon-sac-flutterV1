import 'package:mobil/core/services/service_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServiceController());

    return Scaffold(
      appBar: AppBar(title: const Text("Hizmet Listesi")),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.services.isEmpty) {
          return const Center(child: Text("Henüz hizmet eklenmedi."));
        }

        return ListView.builder(
          itemCount: controller.services.length,
          itemBuilder: (context, index) {
            final service = controller.services[index];
            return ListTile(
              title: Text(service['title']),
              subtitle:
                  Text("Süre: ${service['duration']} dk\n₺${service['price']}"),
            );
          },
        );
      }),
    );
  }
}
