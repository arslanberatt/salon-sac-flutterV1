import 'package:mobil/core/appointments/appointment_controller.dart';
import 'package:mobil/screens/boss/home/widgets/boss_app_bar.dart';
import 'package:mobil/screens/appointments/apointment_card.dart';
import 'package:mobil/utils/constants/colors.dart';
import 'package:mobil/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/utils/loaders/loader_appointment.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentController());
    return Scaffold(
      backgroundColor: ProjectColors.backColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: BossAppBar(),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const LoaderAppointment();
        }

        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: ProjectSizes.pagePadding),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
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
                calendarStyle: CalendarStyle(
                  // Seçili gün rengi ve arka planı
                  selectedDecoration: BoxDecoration(
                    color: ProjectColors.main2Color,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),

                  // Bugünün rengi ve yazı tipi
                  todayDecoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),

                  // Marker stili (event/işaretler için)
                  markerDecoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),

                  // Boş günlerin yazı stili
                  defaultTextStyle: const TextStyle(
                    color: Colors.black87,
                  ),

                  // Hafta sonları için özel stil
                  weekendTextStyle: const TextStyle(
                    color: Colors.redAccent,
                  ),

                  // Takvim hücre padding/margini (isteğe bağlı)
                  cellMargin: const EdgeInsets.all(4),
                ),
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
