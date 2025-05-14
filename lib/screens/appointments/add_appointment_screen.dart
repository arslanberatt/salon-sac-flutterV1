// add_appointment_screen.dart
import 'package:mobil/controllers/appointments/appointment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/appointments/add_appointment_controller.dart';

class AddAppointmentScreen extends StatelessWidget {
  const AddAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddAppointmentController());

    return Scaffold(
      appBar: AppBar(title: const Text("Randevu Ekle")),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField(
                  value: controller.selectedCustomerId.value.isEmpty
                      ? null
                      : controller.selectedCustomerId.value,
                  hint: const Text("Müşteri Seçin"),
                  items: controller.customers
                      .map((c) => DropdownMenuItem(
                            value: c['id'],
                            child: Text(c['name']),
                          ))
                      .toList(),
                  onChanged: (val) =>
                      controller.selectedCustomerId.value = val as String,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField(
                  value: controller.selectedEmployeeId.value.isEmpty
                      ? null
                      : controller.selectedEmployeeId.value,
                  hint: const Text("Çalışan Seçin"),
                  items: controller.employees
                      .map((e) => DropdownMenuItem(
                            value: e['id'],
                            child: Text(e['name']),
                          ))
                      .toList(),
                  onChanged: (val) =>
                      controller.selectedEmployeeId.value = val as String,
                ),
                const SizedBox(height: 10),
                const Text("Hizmet Seçin:"),
                Wrap(
                  spacing: 8,
                  children: controller.services.map((service) {
                    final isSelected =
                        controller.selectedServiceIds.contains(service['id']);
                    return FilterChip(
                      label: Text(service['title']),
                      selected: isSelected,
                      onSelected: (_) {
                        if (isSelected) {
                          controller.selectedServiceIds.remove(service['id']);
                        } else {
                          controller.selectedServiceIds.add(service['id']);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Notlar (opsiyonel)"),
                  onChanged: (val) => controller.notes.value = val,
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: Text(controller.selectedDateTime.value == null
                      ? "Başlangıç Zamanı Seçin"
                      : controller.selectedDateTime.value.toString()),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (picked != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        final dateTime = DateTime(picked.year, picked.month,
                            picked.day, time.hour, time.minute);
                        controller.selectedDateTime.value = dateTime;
                      }
                    }
                  },
                ),
                const SizedBox(height: 20),
                Obx(() => Text(
                    "Toplam Süre: ${controller.totalDuration} dk, Ücret: ₺${controller.totalPrice.toStringAsFixed(2)}")),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final success = await controller.submitAppointment();
                    if (success) {
                      final appointmentController =
                          Get.isRegistered<AppointmentController>()
                              ? Get.find<AppointmentController>()
                              : null;

                      appointmentController?.fetchAppointments();

                      Get.snackbar("Başarılı", "Randevu oluşturuldu");
                      Get.offAllNamed('/main');
                    } else {
                      Get.snackbar("Hata", "Randevu oluşturulamadı");
                    }
                  },
                  child: const Text("Randevu Oluştur"),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
