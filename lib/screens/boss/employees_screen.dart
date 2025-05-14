import 'package:mobil/screens/boss/employee_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/employees/employees_controller.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployeesController());

    return Scaffold(
      appBar: AppBar(title: const Text("Çalışanlar")),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.employees.isEmpty) {
          return const Center(child: Text("Hiç çalışan bulunamadı."));
        }

        return ListView.builder(
          itemCount: controller.employees.length,
          itemBuilder: (context, index) {
            final emp = controller.employees[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(emp["name"]),
                subtitle: Text("📞 ${emp["phone"]} - 🎯 ${emp["role"]}"),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("💰 Maaş: ${emp["salary"]} ₺"),
                    Text("🎁 Prim: %${emp["commissionRate"]}"),
                    Text("💸 Avans: ${emp["advanceBalance"]} ₺"),
                  ],
                ),
                onTap: () {
                  Get.to(() => EmployeeDetailScreen(employee: emp));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
