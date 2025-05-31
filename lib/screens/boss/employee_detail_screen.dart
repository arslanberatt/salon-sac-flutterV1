import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/utils/constants/colors.dart';
import 'package:mobil/utils/constants/sizes.dart';
import '../../core/employees/employee_detail_controller.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> employee;

  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployeeDetailController(employee: employee));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Obx(() => Text(
              controller.name.value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontFamily: 'Teko',
                color: Colors.black87,
              ),
            )),
      ),
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        children: [
          Text("Çalışan Bilgileri",
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: ProjectSizes.spaceBtwItems),

          // Maaş
          TextFormField(
            controller: controller.salaryController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Maaş"),
          ),
          const SizedBox(height: 12),

          // Prim Oranı
          TextFormField(
            controller: controller.commissionController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Prim Oranı (%)"),
          ),
          const SizedBox(height: 24),

          const Text("Rol Seçimi",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          Obx(() => Column(
                children: [
                  _roleCheckbox("patron", "Patron", controller),
                  _roleCheckbox("calisan", "Çalışan", controller),
                  _roleCheckbox("misafir", "Çalışan değil", controller),
                ],
              )),
          const SizedBox(height: 24),

          // Şifre
          TextFormField(
            controller: controller.passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Onay Şifresi"),
          ),
          const SizedBox(height: 32),

          Obx(() => controller.isSaving.value
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ProjectColors.main2Color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: controller.updateEmployee,
                    child: const Text(
                      "Güncelle",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _roleCheckbox(
    String value,
    String label,
    EmployeeDetailController controller,
  ) {
    return CheckboxListTile(
      value: controller.role.value == value,
      onChanged: (_) => controller.role.value = value,
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}
