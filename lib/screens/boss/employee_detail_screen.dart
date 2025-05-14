import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/employees/employee_detail_controller.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> employee;

  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployeeDetailController(employee: employee));

    return Scaffold(
      appBar: AppBar(title: Obx(() => Text(controller.name.value))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFormField(
              controller: controller.salaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Maaş"),
            ),
            TextFormField(
              controller: controller.commissionController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Prim Oranı (%)"),
            ),
            TextFormField(
              controller: controller.advanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Avans Bakiyesi"),
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField(
                  value: controller.role.value,
                  items: const [
                    DropdownMenuItem(value: "patron", child: Text("Patron")),
                    DropdownMenuItem(value: "calisan", child: Text("Çalışan")),
                    DropdownMenuItem(value: "misafir", child: Text("Misafir")),
                  ],
                  onChanged: (value) {
                    if (value != null) controller.role.value = value;
                  },
                  decoration: const InputDecoration(labelText: "Rol"),
                )),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Onay Şifresi"),
            ),
            const SizedBox(height: 20),
            Obx(() => controller.isSaving.value
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: controller.updateEmployee,
                    child: const Text("Güncelle"),
                  )),
          ],
        ),
      ),
    );
  }
}
