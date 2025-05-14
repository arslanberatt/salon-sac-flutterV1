import 'package:mobil/controllers/advance/controllers/advance_approval_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdvanceApprovalScreen extends StatelessWidget {
  const AdvanceApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdvanceApprovalController());

    return Scaffold(
      appBar: AppBar(title: const Text("Avans Talepleri")),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.advanceList.isEmpty) {
          return const Center(child: Text("Hiç avans talebi yok."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.advanceList.length,
          itemBuilder: (context, i) {
            final item = controller.advanceList[i];
            final employee = item['employee'];
            final isPending = item['status'] == 'beklemede';

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee['name'],
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text("Tutar: ₺${item['amount']}"),
                    const SizedBox(height: 4),
                    if ((item['reason'] ?? "").toString().isNotEmpty)
                      Text("Açıklama: ${item['reason']}"),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(item['status'].toUpperCase()),
                          backgroundColor:
                              _getStatusColor(item['status']).withOpacity(0.2),
                          labelStyle:
                              TextStyle(color: _getStatusColor(item['status'])),
                        ),
                        if (isPending)
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check,
                                    color: Colors.green),
                                onPressed: () =>
                                    controller.updateStatus(item['id'], true),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () =>
                                    controller.updateStatus(item['id'], false),
                              ),
                            ],
                          ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'onaylandi':
        return Colors.green;
      case 'reddedildi':
        return Colors.red;
      case 'beklemede':
      default:
        return Colors.orange;
    }
  }
}
