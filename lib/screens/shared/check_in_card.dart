import 'package:get/get.dart';
import 'package:mobil/core/appointments/update_appointment_controller.dart';
import 'package:mobil/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CheckInCard extends StatelessWidget {
  final String title;
  final String customer;
  final String checkIn;
  final String checkOut;
  final String duration;
  final String appointmentId;
  final List<Map<String, dynamic>> services;
  final String status;

  const CheckInCard({
    super.key,
    required this.title,
    required this.customer,
    required this.checkIn,
    required this.checkOut,
    required this.duration,
    required this.appointmentId,
    required this.services,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.lightBlue;
    if (status == 'iptal') {
      statusColor = Colors.red;
    } else if (status == 'tamamlandi') {
      statusColor = Colors.green;
    }

    return GestureDetector(
      onTap: () => showAppointmentDetailModal(
        context,
        appointmentId: appointmentId,
        title: title,
        customer: customer,
        checkIn: checkIn,
        checkOut: checkOut,
        duration: duration,
        services: services,
      ),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ProjectSizes.containerPaddingS)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Iconsax.timer, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(duration,
                            style: TextStyle(
                                fontSize: 12,
                                color: statusColor,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ProjectSizes.xs),
              Text(customer,
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Tahmini Giriş",
                      style: TextStyle(color: Colors.grey)),
                  const Icon(Iconsax.arrow_swap_horizontal, color: Colors.grey),
                  const Text("Tahmini Çıkış",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: ProjectSizes.s),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(checkIn,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(checkOut,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showAppointmentDetailModal(
  BuildContext context, {
  required String appointmentId,
  required String title,
  required String customer,
  required String checkIn,
  required String checkOut,
  required String duration,
  required List<Map<String, dynamic>> services,
}) {
  final editController = Get.put(EditAppointmentController());

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
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
                IconButton(
                  icon: const Icon(Iconsax.edit, color: Colors.black54),
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tahmini Giriş",
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(checkIn,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
                const Icon(Iconsax.arrow_swap_horizontal, color: Colors.grey),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Tahmini Çıkış",
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(checkOut,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      editController.updateAppointmentStatus(
                          appointmentId, "iptal");
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                    label: const Text("İptal Et",
                        style: TextStyle(color: Colors.red)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      editController.updateAppointmentStatus(
                          appointmentId, "tamamlandi");
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text("Onayla"),
                    style: ElevatedButton.styleFrom(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
