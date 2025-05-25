import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/core/user_session_controller.dart';
import 'package:mobil/screens/boss/home/widgets/boss_app_bar.dart';
import 'package:mobil/screens/employee/advance_request_screen.dart';
import 'package:mobil/utils/constants/colors.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';
import '../../core/salary/employee_salary_controller.dart';

class EmployeeSalaryScreen extends StatelessWidget {
  EmployeeSalaryScreen({super.key});

  final controller = Get.put(EmployeeSalaryController());
  final session = Get.find<UserSessionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(249, 255, 255, 255),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: BossAppBar(),
      ),
      body: Obx(() {
        if (session.id.isEmpty || controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final gross = controller.employeeSalary.value;
        final advance = controller.totalAdvance.value;
        final net = controller.netSalary.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Görsel
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/images/kasa.png",
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              /// Özet Kart
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      buildSummaryRow("Brüt Maaş", gross),
                      buildSummaryRow("Toplam Avans", advance),
                      const Divider(height: 32),
                      buildSummaryRow("Net Maaş", net, isBold: true),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Bu maaş bilgileri sistemden alınan en güncel verilere dayanmaktadır. Net maaş, avans düşülerek hesaplanır.",
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProjectColors.main2Color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => RequestAdvanceScreen());
                  },
                  label: const Text(
                    "Avans Talep Et",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// 🔘 Avans Talep Et Butonu
        );
      }),
    );
  }

  Widget buildSummaryRow(String title, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: 16,
            ),
          ),
          Text(
            "₺${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
              color: isBold ? ProjectColors.main2Color : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
