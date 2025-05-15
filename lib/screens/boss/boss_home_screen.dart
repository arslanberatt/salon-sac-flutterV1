import 'dart:async';

import 'package:intl/intl.dart';
import 'package:mobil/controllers/appointments/appointment_controller.dart';
import 'package:mobil/screens/boss/transaction_screen.dart';
import 'package:mobil/screens/customers/add_customer_screen.dart';
import 'package:mobil/screens/employee/performance_screen.dart';
import 'package:mobil/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../shared/stat_card.dart';
import '../shared/check_in_card.dart';

class BossHomeScreen extends StatelessWidget {
  const BossHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentController());

    final name = "Berat Arslan";
    final hello = "Merhaba,";
    final gridContainerTitle = "Kısayollar";

    final mainColorLight = const Color.fromRGBO(71, 172, 211, 1);
    final mainColorNormal = const Color.fromRGBO(30, 142, 186, 1);
    final whiteColor = Colors.white;
    final blackColor = Colors.black;

    BoxDecoration generateCardTheme(Color startColor, Color endColor) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [startColor, endColor],
        ),
        borderRadius: BorderRadius.circular(ProjectSizes.md),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey[100],
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                "assets/images/logo.jpg",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: const Text(
            "SALON SAÇ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Domine',
            ),
          ),
        ),
      ),
      body: Obx(
        () {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: ProjectSizes.pagePadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: ProjectSizes.IconM),
                          Text(hello,
                              style: Theme.of(context).textTheme.headlineSmall),
                          Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Get.to(AddCustomerScreen()),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            "assets/images/employee.png",
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ProjectSizes.containerPaddingL),
                  Text(gridContainerTitle,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: ProjectSizes.containerPaddingS),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          onTap: () => Get.to(TransactionScreen()),
                          title: "Kasa",
                          value: "15000₺",
                          isLoading: controller.loading.value,
                          cardTextColor: whiteColor,
                          icon: Iconsax.empty_wallet,
                          decoration: generateCardTheme(
                              mainColorNormal, mainColorLight),
                        ),
                      ),
                      const SizedBox(
                        width: ProjectSizes.s,
                      ),
                      Expanded(
                        child: StatCard(
                          title: "Randevu",
                          value: "${controller.waitingAppointments.value}",
                          isLoading: controller.loading.value,
                          cardTextColor: blackColor,
                          icon: Iconsax.calendar_search,
                          decoration: generateCardTheme(whiteColor, whiteColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: ProjectSizes.s,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          onTap: () => Get.to(PerformanceScreen()),
                          title: "Performans",
                          value: "${controller.employees.length} Çalışan",
                          cardTextColor: blackColor,
                          icon: Iconsax.calendar_edit,
                          decoration: generateCardTheme(whiteColor, whiteColor),
                        ),
                      ),
                      const SizedBox(
                        width: ProjectSizes.s,
                      ),
                      Expanded(
                        child: StatCard(
                          onTap: () => Get.to(AddCustomerScreen()),
                          title: "Müşteriler",
                          value: "Müşteri Ekle",
                          cardTextColor: blackColor,
                          icon: Iconsax.profile_add,
                          decoration: generateCardTheme(whiteColor, whiteColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ProjectSizes.containerPaddingM),
                  Text(
                    "Yaklaşan Randevular",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: ProjectSizes.containerPaddingS),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.filteredAppointments.length,
                    itemBuilder: (context, index) {
                      final appt = controller.filteredAppointments[index];
                      final employee =
                          controller.getEmployeeName(appt['employeeId']);
                      final customer =
                          controller.getCustomerName(appt['customerId']);
                      final startTime =
                          controller.formatTime(appt['startTime']);
                      final endTime = controller.formatTime(appt['endTime']);
                      final duration = controller.calculateDuration(
                        appt['startTime'],
                        appt['endTime'],
                      );

                      return Column(
                        children: [
                          CheckInCard(
                            title: employee,
                            customer: customer,
                            checkIn: startTime,
                            checkOut: endTime,
                            duration: duration,
                          ),
                          const SizedBox(
                              height: ProjectSizes.containerPaddingS),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

String formatTime(String timeString) {
  final date = DateTime.parse(timeString);
  return DateFormat.Hm().format(date);
}

String calculateDuration(String start, String end) {
  final startTime = DateTime.parse(start);
  final endTime = DateTime.parse(end);
  final diff = endTime.difference(startTime);
  return "${diff.inHours} saat ${diff.inMinutes % 60} dk";
}
