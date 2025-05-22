import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobil/core/advance/controllers/advance_approval_controller.dart';
import 'package:mobil/screens/boss/advance_approval_screen.dart';
import '../../core/employees/employees_controller.dart';
import '../../../screens/boss/employee_detail_screen.dart';

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
                    if (count == 0) return const SizedBox();

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

        final allEmployees = employeeController.employees;
        final bosses = allEmployees
            .where((e) => e["role"]?.toUpperCase() == "PATRON")
            .toList();
        final workers = allEmployees
            .where((e) => e["role"]?.toUpperCase() == "CALISAN")
            .toList();
        final guests = allEmployees
            .where((e) => e["role"]?.toUpperCase() == "MISAFIR")
            .toList();

        if (allEmployees.isEmpty) {
          return const Center(child: Text("Hiç çalışan bulunamadı."));
        }

        return RefreshIndicator(
          onRefresh: employeeController.fetchEmployees,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            children: [
              if (bosses.isNotEmpty) ...[
                const SectionTitle(title: "Patronlar"),
                ...bosses.map((emp) => ZenithProjectCard(
                      employee: emp,
                      onTap: () async {
                        final result = await Get.to(
                            () => EmployeeDetailScreen(employee: emp));
                        if (result is Map<String, dynamic>) {
                          final index = employeeController.employees
                              .indexWhere((e) => e["id"] == result["id"]);
                          if (index != -1) {
                            employeeController.employees[index] = result;
                            employeeController.employees.refresh();
                          }
                        }
                      },
                    )),
              ],
              if (workers.isNotEmpty) ...[
                const SectionTitle(title: "Çalışanlar"),
                ...workers.map((emp) => ZenithProjectCard(
                      employee: emp,
                      onTap: () async {
                        final result = await Get.to(
                            () => EmployeeDetailScreen(employee: emp));
                        if (result is Map<String, dynamic>) {
                          final index = employeeController.employees
                              .indexWhere((e) => e["id"] == result["id"]);
                          if (index != -1) {
                            employeeController.employees[index] = result;
                            employeeController.employees.refresh();
                          }
                        }
                      },
                    )),
              ],
              if (guests.isNotEmpty) ...[
                const SectionTitle(title: "Misafirler"),
                ...guests.map((emp) => ZenithProjectCard(
                      employee: emp,
                      onTap: () async {
                        final result = await Get.to(
                            () => EmployeeDetailScreen(employee: emp));
                        if (result is Map<String, dynamic>) {
                          final index = employeeController.employees
                              .indexWhere((e) => e["id"] == result["id"]);
                          if (index != -1) {
                            employeeController.employees[index] = result;
                            employeeController.employees.refresh();
                          }
                        }
                      },
                    )),
              ],
            ],
          ),
        );
      }),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, bottom: 4, right: 16),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class ZenithProjectCard extends StatelessWidget {
  final Map<String, dynamic> employee;
  final VoidCallback onTap;

  const ZenithProjectCard({
    super.key,
    required this.employee,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String name = employee["name"] ?? "İsimsiz";
    final String phone = employee["phone"] ?? "-";
    final double salary = (employee["salary"] ?? 0).toDouble();
    final double commissionRate = (employee["commissionRate"] ?? 0).toDouble();
    final double advanceBalance = (employee["advanceBalance"] ?? 0).toDouble();
    final String role = employee["role"]?.toUpperCase() ?? "ÇALIŞAN";

    Color badgeColor = Colors.grey;
    if (role == "PATRON") badgeColor = Colors.orange;
    if (role == "CALISAN") badgeColor = Colors.blue;
    if (role == "MISAFIR") badgeColor = Colors.black;

    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            role,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          value: commissionRate / 100,
                          strokeWidth: 4,
                          backgroundColor: Colors.grey.shade200,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        "%${commissionRate.toInt()}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              _buildInfoColumn("Telefon", phone),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn("Maaş", "₺${salary.toStringAsFixed(0)}"),
                  _buildInfoColumn(
                      "Avans", "₺${advanceBalance.toStringAsFixed(0)}"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
      ],
    );
  }
}
