import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/appointments/appointment_controller.dart';
import 'package:mobil/screens/shared/check_in_card.dart';
import 'package:mobil/utils/constants/sizes.dart';
import 'package:mobil/utils/loaders/loader_appointment.dart';

class UpcomingAppointmentsSection extends StatelessWidget {
  const UpcomingAppointmentsSection({super.key, required this.controller});

  final AppointmentController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Yaklaşan Randevular",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: ProjectSizes.containerPaddingS),
        Obx(() {
          if (controller.loading.value) {
            return const LoaderAppointment();
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.todayAppointments.length,
            itemBuilder: (context, index) {
              final appt = controller.todayAppointments[index];
              return Padding(
                padding: const EdgeInsets.only(
                    bottom: ProjectSizes.containerPaddingS),
                child: CheckInCard(
                  status: appt['status'] ?? "Bilinmiyor",
                  title: controller.getEmployeeName(appt['employeeId']) ?? "-",
                  customer:
                      controller.getCustomerName(appt['customerId']) ?? "-",
                  checkIn: controller.formatTime(appt['startTime']),
                  checkOut: controller.formatTime(appt['endTime']),
                  duration: controller.calculateDuration(
                    appt['startTime'],
                    appt['endTime'],
                  ),
                  appointmentId: appt['id'],
                  services:
                      controller.getServicesByIds(appt['serviceIds'] ?? []),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
