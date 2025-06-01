import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mobil/core/appointments/edit_appointment_controller.dart';
import 'package:mobil/utils/constants/sizes.dart';

class EditAppointmentScreen extends StatefulWidget {
  final String appointmentId;
  const EditAppointmentScreen({super.key, required this.appointmentId});

  @override
  State<EditAppointmentScreen> createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  late EditAppointmentController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(EditAppointmentController());
    controller.loadAppointment(widget.appointmentId);
  }

  @override
  void dispose() {
    Get.delete<EditAppointmentController>(); // sayfa kapanınca controller'ı kaldır
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "SALON SAÇ",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontFamily: 'Teko',
            color: Colors.black87,
          ),
        ),
      ),
      body: Obx(() {
        // Eğer veri henüz gelmemişse beklet
        if (controller.loading.value && controller.selectedDateTime.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: ProjectSizes.spaceBtwItems),

                Row(
                  children: [
                    Text("Randevu Düzenle",
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),

                const SizedBox(height: ProjectSizes.spaceBtwItems),

                /// 📝 Not Alanı
                TextFormField(
                  controller: controller.notesController,
                  decoration: const InputDecoration(
                    labelText: "Not (Opsiyonel)",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                /// 📅 Tarih Seçimi
                Obx(() => ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      title: Text(
                        controller.selectedDateTime.value == null
                            ? "Başlangıç Zamanı Seçin"
                            : DateFormat("dd.MM.yyyy HH:mm")
                                .format(controller.selectedDateTime.value!),
                      ),
                      trailing: const Icon(Icons.calendar_month),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDateTime.value ?? DateTime.now(),
                          firstDate: DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                        );
                        if (picked != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                controller.selectedDateTime.value ?? DateTime.now()),
                          );
                          if (time != null) {
                            final dt = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                              time.hour,
                              time.minute,
                            );
                            controller.selectedDateTime.value = dt;
                          }
                        }
                      },
                    )),

                const SizedBox(height: 24),

                /// 💾 Kaydet Butonu
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Iconsax.save_2),
                        onPressed: controller.loading.value
                            ? null
                            : () async {
                                final success = await controller.updateAppointment();
                                if (success) {
                                  Get.offAllNamed('/forRefresh'); // Refresh page
                                }
                              },
                        label: controller.loading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Kaydet"),
                      ),
                    )),
              ],
            ),
          ),
        );
      }),
    );
  }
}
