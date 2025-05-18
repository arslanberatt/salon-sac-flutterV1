import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobil/core/appointments/update_appointment_controller.dart';
import 'package:mobil/screens/appointment/appointment_status_actions.dart';
import 'package:mobil/screens/appointments/edit_appointment_screen.dart';

void showAppointmentDetailModal(
  BuildContext context, {
  required String appointmentId,
  required String title,
  required String customer,
  required String checkIn,
  required String checkOut,
  required String duration,
  required String status,
  required List<Map<String, dynamic>> services,
}) {
  final controller = Get.put(UpdateAppointmentController());
  controller.appointmentStatus.value = status;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                if (status != "tamamlandi" && status != "iptal")
                  IconButton(
                    icon: const Icon(Iconsax.edit, color: Colors.black54),
                    onPressed: () => Get.to(() =>
                        EditAppointmentScreen(appointmentId: appointmentId)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Müşteri: $customer",
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Tahmini Giriş",
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(checkIn,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ]),
                const Icon(Iconsax.arrow_swap_horizontal, color: Colors.grey),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  const Text("Tahmini Çıkış",
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(checkOut,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ]),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Iconsax.timer, size: 16, color: Colors.lightBlue),
                const SizedBox(width: 6),
                Text("Süre: $duration",
                    style: const TextStyle(color: Colors.lightBlue)),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Hizmetler",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: services
                  .map((service) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                            "• ${service['title']} - ${service['duration']} dk - ${service['price']}₺"),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 32),
            AppointmentStatusActions(
                appointmentId: appointmentId, status: status),
          ],
        ),
      ),
    ),
  );
}
