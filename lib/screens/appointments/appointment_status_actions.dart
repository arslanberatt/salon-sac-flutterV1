import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/appointments/update_appointment_controller.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';

class AppointmentStatusActions extends StatefulWidget {
  final String appointmentId;
  final String status;

  const AppointmentStatusActions({
    super.key,
    required this.appointmentId,
    required this.status,
  });

  @override
  State<AppointmentStatusActions> createState() =>
      _AppointmentStatusActionsState();
}

class _AppointmentStatusActionsState extends State<AppointmentStatusActions> {
  late final TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    priceController = TextEditingController();
  }

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UpdateAppointmentController>();

    if (widget.status == "tamamlandi" || widget.status == "iptal") {
      return const SizedBox();
    }

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
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.updateAppointmentStatus(
                      widget.appointmentId, "iptal");
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
                    widget.appointmentId,
                    "tamamlandi",
                    price: price,
                  );
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
