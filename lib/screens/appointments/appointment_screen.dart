import 'package:mobil/core/appointments/appointment_controller.dart';
import 'package:mobil/screens/common/appointment_loading_screen.dart';
import 'package:mobil/screens/appointments/apointment_card.dart';
import 'package:mobil/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey[100],
          elevation: 0,
          title: const Text(
            "Randevular",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Domine',
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const AppointmentLoadingScreen();
        }

        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: ProjectSizes.pagePadding),
          child: Column(
            children: [
              TableCalendar(
                locale: 'tr_TR',
                focusedDay: controller.selectedDate.value,
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                calendarFormat: CalendarFormat.week,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerVisible: false,
                selectedDayPredicate: (day) =>
                    isSameDay(controller.selectedDate.value, day),
                onDaySelected: (selectedDay, focusedDay) {
                  final normalized = DateTime(
                      selectedDay.year, selectedDay.month, selectedDay.day);
                  controller.setSelectedDate(normalized);
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                child: controller.filteredAppointments.isEmpty
                    ? const Center(child: Text("Bu tarihte randevu yok."))
                    : RefreshIndicator(
                        onRefresh: () async {
                          await controller.fetchAppointments();
                        },
                        child: ListView.builder(
                          itemCount: controller.filteredAppointments.length,
                          itemBuilder: (context, index) {
                            final appt = controller.filteredAppointments[index];
                            return Column(
                              children: [
                                AppointmentCard(
                                  title: controller
                                      .getEmployeeName(appt['employeeId']),
                                  customer:
                                      "Müşteri: ${controller.getCustomerName(appt['customerId'])}",
                                  checkIn:
                                      controller.formatTime(appt['startTime']),
                                  checkOut:
                                      controller.formatTime(appt['endTime']),
                                  duration:
                                      "${controller.calculateDuration(appt['startTime'], appt['endTime'])}",
                                  appointmentId: appt['id'],
                                  services: controller
                                      .getServicesByIds(appt['serviceIds']),
                                  status: appt['status'],
                                ),
                                const SizedBox(
                                    height: ProjectSizes.containerPaddingS),
                              ],
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'tamamlandi':
        return Colors.green;
      case 'iptal':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
