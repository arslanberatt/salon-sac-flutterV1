import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/appointments/appointment_controller.dart';
import 'package:mobil/core/transactions/transaction_controller.dart';
import 'package:mobil/core/user_info_controller.dart';
import 'package:mobil/screens/boss/home/widgets/boss_app_bar.dart';
import 'package:mobil/screens/boss/home/widgets/greeting_section.dart';
import 'package:mobil/screens/boss/home/widgets/stat_cards_section.dart';
import 'package:mobil/screens/boss/home/widgets/upcoming_appointments_section.dart';
import 'package:mobil/utils/constants/colors.dart';
import 'package:mobil/utils/constants/sizes.dart';

class BossHomeScreen extends StatelessWidget {
  const BossHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentController = Get.put(AppointmentController());
    final transactionController = Get.put(TransactionController());
    final userInfoController = Get.put(UserInfoController());

    return Scaffold(
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
            await transactionController.fetchTransactions();
            await userInfoController.fetchUserInfo();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GreetingSection(
                  userInfoController: userInfoController,
                ),
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
