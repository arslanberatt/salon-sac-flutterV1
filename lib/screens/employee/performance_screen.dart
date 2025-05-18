import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/employees/performance_controller.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PerformanceController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Aylık Performans"),
        centerTitle: true,
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Bu Ayın Lideri:",
                  style: Theme.of(context).textTheme.titleMedium),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.emoji_events, color: Colors.amber),
                  title: Text(controller.topPerformerName.value),
                  trailing:
                      Text("${controller.topPerformerCount.value} müşteri"),
                ),
              ),
              const SizedBox(height: 20),
              Text("Tüm Çalışanlar:",
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.currentMonthStats.length,
                  itemBuilder: (context, index) {
                    final item = controller.currentMonthStats[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text("${index + 1}")),
                      title: Text(item['name']),
                      trailing: Text("${item['count']} müşteri"),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
