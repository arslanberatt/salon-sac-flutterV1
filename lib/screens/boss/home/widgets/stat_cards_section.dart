import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobil/core/appointments/appointment_controller.dart';
import 'package:mobil/core/transactions/transaction_controller.dart';
import 'package:mobil/screens/appointments/appointment_screen.dart';
import 'package:mobil/screens/boss/manage_service_screen.dart';
import 'package:mobil/screens/boss/transaction_screen.dart';
import 'package:mobil/screens/customers/add_customer_screen.dart';
import 'package:mobil/screens/employee/stat_card.dart';
import 'package:mobil/utils/constants/sizes.dart';

class StatCardsSection extends StatelessWidget {
  const StatCardsSection({
    super.key,
    required this.appointmentController,
    required this.transactionController,
  });

  final AppointmentController appointmentController;
  final TransactionController transactionController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Kısayollar", style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: ProjectSizes.containerPaddingS),
        Row(
          children: [
            Expanded(
              child: Obx(() => StatCard(
                    onTap: () => Get.to(TransactionScreen()),
                    title: "Kasa",
                    value: (transactionController.totalIncome -
                                transactionController.totalExpense)
                            .toStringAsFixed(0) +
                        "TL",
                    isLoading: appointmentController.loading.value,
                    cardTextColor: Colors.white,
                    icon: Iconsax.empty_wallet,
                    decoration: _generateCardTheme(),
                  )),
            ),
            const SizedBox(width: ProjectSizes.s),
            Expanded(
              child: Obx(() => StatCard(
                    onTap: () => GetPage(
                        name: '/appointments', page: () => AppointmentScreen()),
                    title: "Aktif Randevu",
                    value:
                        "${appointmentController.waitingAppointments.value} adet",
                    isLoading: appointmentController.loading.value,
                    cardTextColor: Colors.black,
                    icon: Iconsax.calendar_search,
                    decoration: _generateCardTheme(isWhite: true),
                  )),
            ),
          ],
        ),
        const SizedBox(height: ProjectSizes.s),
        Row(
          children: [
            Expanded(
                child: StatCard(
              onTap: () => Get.to(() => ManageServicesScreen()),
              title: "Hizmetler",
              value: "Hizmet Ekle",
              cardTextColor: Colors.black,
              icon: Iconsax.setting_2,
              decoration: _generateCardTheme(isWhite: true),
            )),
            const SizedBox(width: ProjectSizes.s),
            Expanded(
              child: StatCard(
                onTap: () => Get.to(AddCustomerScreen()),
                title: "Müşteriler",
                value: "Müşteri Ekle",
                cardTextColor: Colors.black,
                icon: Iconsax.profile_add,
                decoration: _generateCardTheme(isWhite: true),
              ),
            ),
          ],
        ),
      ],
    );
  }

  BoxDecoration _generateCardTheme({bool isWhite = false}) {
    return BoxDecoration(
      gradient: isWhite
          ? null
          : const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(30, 142, 186, 1),
                Color.fromRGBO(71, 172, 211, 1),
              ],
            ),
      color: isWhite ? Colors.white : null,
      borderRadius: BorderRadius.circular(ProjectSizes.md),
    );
  }
}
