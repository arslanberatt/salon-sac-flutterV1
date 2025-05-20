import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobil/core/appointments/appointment_controller.dart';
import 'package:mobil/utils/constants/colors.dart';

class DatePickerRow extends StatelessWidget {
  const DatePickerRow({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentController = Get.find<AppointmentController>();
    final today = DateTime.now();

    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (_, index) {
          final date = today.add(Duration(days: index));

          return Obx(() {
            final isSelected = DateFormat('yyyy-MM-dd')
                    .format(appointmentController.selectedDate.value) ==
                DateFormat('yyyy-MM-dd').format(date);

            return GestureDetector(
              onTap: () {
                appointmentController.setSelectedDate(date);
              },
              child: Container(
                width: 60,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isSelected ? ProjectColors.main2Color : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? ProjectColors.main2Color
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.E('tr_TR').format(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat.d().format(date),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
