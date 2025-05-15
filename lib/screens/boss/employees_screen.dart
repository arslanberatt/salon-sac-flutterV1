import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobil/controllers/advance/controllers/advance_approval_controller.dart';
import 'package:mobil/screens/boss/advance_approval_screen.dart';
import '../../../controllers/employees/employees_controller.dart';
import '../../../screens/boss/employee_detail_screen.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeController = Get.put(EmployeesController());
    final advanceApprovalController = Get.put(AdvanceApprovalController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey[100],
          elevation: 0,
          title: const Text(
            "Çalışanlar",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Domine',
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(Iconsax.notification, size: 28),
                    onPressed: () {
                      Get.to(() => const AdvanceApprovalScreen());
                    },
                  ),
                  Obx(() {
                    final count =
                        advanceApprovalController.advanceWaitList.length;
                    if (count == 0) return const SizedBox(); // hiç gösterme

                    return Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints:
                            const BoxConstraints(minWidth: 20, minHeight: 20),
                        child: Center(
                          child: Text(
                            count > 99 ? "99+" : count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (employeeController.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (employeeController.employees.isEmpty) {
          return const Center(child: Text("Hiç çalışan bulunamadı."));
        }

        return ListView.builder(
          itemCount: employeeController.employees.length,
          itemBuilder: (context, index) {
            final emp = employeeController.employees[index];
            return _EmployeeCard(
              employee: emp,
              onTap: () => Get.to(() => EmployeeDetailScreen(employee: emp)),
            );
          },
        );
      }),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final Map<String, dynamic> employee;
  final VoidCallback onTap;

  const _EmployeeCard({
    required this.employee,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = employee["name"] ?? "İsimsiz";
    final phone = employee["phone"] ?? "-";
    final role = employee["role"] ?? "-";
    final salary = employee["salary"] ?? 0;
    final commissionRate = employee["commissionRate"] ?? 0;
    final advanceBalance = employee["advanceBalance"] ?? 0;

    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ProjectSizes.s),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ProjectSizes.s),
        child: Padding(
          padding: const EdgeInsets.all(ProjectSizes.containerPaddingS),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 Ad ve Rol
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: ProjectColors.main2Color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(role,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: ProjectColors.main2Color,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // ☎ Telefon
              Row(
                children: [
                  const Icon(Iconsax.call,
                      size: 16, color: ProjectColors.grayColor),
                  const SizedBox(width: 6),
                  Text(phone,
                      style: const TextStyle(color: ProjectColors.grayColor)),
                ],
              ),

              const SizedBox(height: 12),

              // 💰 Maaş - 🎁 Prim - 💸 Avans
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfo("Maaş", "$salary ₺"),
                  _buildInfo("Prim", "%$commissionRate"),
                  _buildInfo("Avans", "$advanceBalance ₺"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 14, color: ProjectColors.grayColor)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
