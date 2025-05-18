import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mobil/core/appointments/edit_appointment_controller.dart';

class EditAppointmentScreen extends StatefulWidget {
  final String appointmentId;
  const EditAppointmentScreen({super.key, required this.appointmentId});

  @override
  State<EditAppointmentScreen> createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  final controller = Get.put(EditAppointmentController());

  @override
  void initState() {
    super.initState();
    controller.loadAppointment(widget.appointmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Randevuyu Güncelle")),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// 📝 Not (editable)
                TextFormField(
                  controller: controller.notesController,
                  decoration: const InputDecoration(
                    labelText: "Not (Opsiyonel)",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                /// 🕒 Başlangıç Zamanı (editable)
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
                          initialDate: controller.selectedDateTime.value ??
                              DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 30)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 30)),
                        );
                        if (picked != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                controller.selectedDateTime.value ??
                                    DateTime.now()),
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

                /// 💾 Güncelle Butonu
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: controller.loading.value
                            ? null
                            : () async {
                                final success =
                                    await controller.updateAppointment();
                                if (success) {
                                  Get.offAllNamed('/forRefresh');
                                }
                              },
                        icon: const Icon(Iconsax.save_2),
                        label: controller.loading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
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
