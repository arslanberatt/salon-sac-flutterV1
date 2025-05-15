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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Obx(() => Text(
              controller.name.value,
              style: const TextStyle(color: Colors.black),
            )),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Çalışan Bilgileri",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.salaryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Maaş"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.commissionController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Prim Oranı (%)"),
              ),
              const SizedBox(height: 12),
              const Text(
                "Rol Seçimi",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Obx(() => Column(
                    children: [
                      _roleCheckbox("patron", "Patron", controller),
                      _roleCheckbox("calisan", "Çalışan", controller),
                      _roleCheckbox("misafir", "Misafir", controller),
                    ],
                  )),
              const SizedBox(height: 24),
              TextFormField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Onay Şifresi"),
              ),
              const SizedBox(height: 24),
              Obx(() => controller.isSaving.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:
                            controller.updateEmployee, // 🚀 doğrudan çağır
                        child: const Text("Güncelle"),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCheckbox(
      String value, String label, EmployeeDetailController controller) {
    return CheckboxListTile(
      value: controller.role.value == value,
      onChanged: (_) {
        controller.role.value = value;
      },
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
