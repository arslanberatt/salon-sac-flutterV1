import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/appointments/update_appointment_controller.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';

class AppointmentStatusActions extends StatelessWidget {
  final String appointmentId;
  final String status;
  const AppointmentStatusActions({
    super.key,
    required this.appointmentId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UpdateAppointmentController>();
    final priceController = TextEditingController();

    if (status == "tamamlandi" || status == "iptal") return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Toplam Fiyat (₺)",
            style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Örn: 250",
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.updateAppointmentStatus(appointmentId, "iptal");
                  Navigator.pop(context);
                },
                label: const Text("Randevu iptali",
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
                  final price = double.tryParse(priceController.text.trim());
                  if (price == null) {
                    CustomSnackBar.errorSnackBar(
                      title: "Hata",
                      message: "Lütfen geçerli bir fiyat girin.",
                    );
                    return;
                  }
                  controller.updateAppointmentStatus(
                      appointmentId, "tamamlandi",
                      price: price);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Onayla"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
