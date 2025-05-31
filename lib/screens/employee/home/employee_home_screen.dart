import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobil/core/appointments/appointment_controller.dart';
import 'package:mobil/core/core/user_session_controller.dart';
import 'package:mobil/core/user_info_controller.dart';
import 'package:mobil/screens/appointments/apointment_card.dart';
import 'package:mobil/screens/boss/home/widgets/boss_app_bar.dart';
import 'package:mobil/screens/boss/home/widgets/greeting_section.dart';
import 'package:mobil/screens/customers/add_customer_screen.dart';
import 'package:mobil/screens/employee/stat_card.dart' as emp;
import 'package:mobil/utils/constants/colors.dart';
import 'package:mobil/utils/constants/sizes.dart';
import 'package:mobil/utils/loaders/loader_appointment.dart';
import 'package:mobil/utils/loaders/sadFace.dart';
import 'widgets/date_picker_row.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<UserSessionController>();
    Future.delayed(Duration.zero, () {
      session.autoLogoutIfGuest();
    });
    final appointmentController = Get.put(AppointmentController());
    final userInfoController = Get.put(UserInfoController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: BossAppBar(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            if (appointmentController.loading.value) {
              return const Center(child: LoaderAppointment());
            }

            final todayList = appointmentController.todayAppointments;
            final filtered = appointmentController.filteredAppointments;

            return RefreshIndicator(
              onRefresh: appointmentController.fetchAppointments,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GreetingSection(userInfoController: userInfoController),
                  SizedBox(height: ProjectSizes.containerPaddingS),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: emp.StatCard(
                          title: 'Bugün',
                          value: todayList.length.toString(),
                          icon: Icons.calendar_today,
                          decoration: BoxDecoration(
                            color: ProjectColors.backColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          cardTextColor: Colors.grey.shade900,
                        ),
                      ),
                      Expanded(
                        child: emp.StatCard(
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
                  SizedBox(height: ProjectSizes.containerPaddingL),
                  const DatePickerRow(),
                  SizedBox(height: ProjectSizes.containerPaddingM),
                  Expanded(
                    child: filtered.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 100),
                              Center(child: SadFace()),
                              Center(
                                child: Text(
                                  "Bugün randevu yok",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final appt = filtered[index];
                              return Column(
                                children: [
                                  AppointmentCard(
                                    status: appt['status'] ?? "bilinmiyor",
                                    title: appointmentController
                                        .getEmployeeName(appt['employeeId']),
                                    customer: appointmentController
                                        .getCustomerName(appt['customerId']),
                                    checkIn: appointmentController
                                        .formatTime(appt['startTime']),
                                    checkOut: appointmentController
                                        .formatTime(appt['endTime']),
                                    duration:
                                        appointmentController.calculateDuration(
                                      appt['startTime'],
                                      appt['endTime'],
                                    ),
                                    appointmentId: appt['id'],
                                    services:
                                        appointmentController.getServicesByIds(
                                      appt['serviceIds'] ?? [],
                                    ),
                                    notes: appt['notes'] ?? '',
                                  ),
                                  SizedBox(
                                      height: ProjectSizes.containerPaddingS),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
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
