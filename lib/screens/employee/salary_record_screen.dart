import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/salary/salary_record_controller.dart';

class SalaryRecordScreen extends StatelessWidget {
  const SalaryRecordScreen({super.key});

  String formatDate(String? iso) {
    if (iso == null) return "-";
    final dt = DateTime.tryParse(iso);
    if (dt == null) return "-";
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SalaryRecordController());

    return Scaffold(
      appBar: AppBar(title: const Text("Maaş / Prim / Avans")),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.records.isEmpty) {
          return const Center(child: Text("Kayıt bulunamadı."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.records.length,
          itemBuilder: (_, i) {
            final rec = controller.records[i];
            final typeLabel = rec['type'];
            final isApproved = rec['approved'] == true;

            IconData icon;
            Color color;

            switch (typeLabel) {
              case 'prim':
                icon = Icons.star;
                color = Colors.green;
                break;
              case 'avans':
                icon = Icons.money_off;
                color = Colors.orange;
                break;
              default:
                icon = Icons.payments;
                color = Colors.blue;
            }

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(icon, color: color),
                ),
                title: Text("${rec['description']}"),
                subtitle: Text(
                  "${typeLabel.toUpperCase()} | ${formatDate(rec['date'])}",
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("₺${rec['amount']}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (!isApproved)
                      const Text("Bekliyor",
                          style: TextStyle(fontSize: 12, color: Colors.orange))
                    else
                      const Text("Onaylı",
                          style: TextStyle(fontSize: 12, color: Colors.green)),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
