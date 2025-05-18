import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/appointments/appointment_controller.dart';
import 'package:mobil/core/transactions/transaction_controller.dart';
import 'package:mobil/screens/boss/boss_home/widgets/boss_app_bar.dart';
import 'package:mobil/screens/boss/boss_home/widgets/greeting_section.dart';
import 'package:mobil/screens/boss/boss_home/widgets/stat_cards_section.dart';
import 'package:mobil/screens/boss/boss_home/widgets/upcoming_appointments_section.dart';
import 'package:mobil/utils/constants/sizes.dart';

class BossHomeScreen extends StatelessWidget {
  const BossHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentController = Get.put(AppointmentController());
    final transactionController = Get.put(TransactionController());

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: BossAppBar(),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: ProjectSizes.pagePadding),
        child: RefreshIndicator(
          onRefresh: () async {
            await appointmentController.fetchAppointments();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GreetingSection(),
                const SizedBox(height: ProjectSizes.containerPaddingL),
                StatCardsSection(
                  appointmentController: appointmentController,
                  transactionController: transactionController,
                ),
                const SizedBox(height: ProjectSizes.containerPaddingM),
                UpcomingAppointmentsSection(controller: appointmentController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
