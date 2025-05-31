import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobil/core/appointments/add_appointment_controller.dart';
import 'package:mobil/core/appointments/appointment_controller.dart';
import 'package:mobil/core/core/user_session_controller.dart';
import 'package:mobil/utils/constants/sizes.dart';
import 'package:mobil/utils/loaders/loader_appointment.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';

class AddAppointmentScreen extends StatelessWidget {
  const AddAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddAppointmentController());
    final session = Get.find<UserSessionController>();

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
        if (controller.loading.value) {
          return const Center(child: LoaderAppointment());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔍 Müşteri Arama
                TypeAheadField<Map<String, dynamic>>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: controller.customerNameController,
                    focusNode: controller.customerFocusNode,
                    decoration: const InputDecoration(
                      labelText: "Müşteri Ara",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  suggestionsCallback: (pattern) => controller.customers
                      .where((c) => c['name']
                          .toLowerCase()
                          .contains(pattern.toLowerCase()))
                      .toList(),
                  itemBuilder: (_, suggestion) =>
                      ListTile(title: Text(suggestion['name'])),
                  onSuggestionSelected: (suggestion) {
                    controller.selectedCustomerId.value = suggestion['id'];
                    controller.customerNameController.text = suggestion['name'];
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: session.isPatron
                      ? (controller.selectedEmployeeId.value.isNotEmpty
                          ? controller.selectedEmployeeId.value
                          : null)
                      : session.id.value,
                  items: controller.employees
                      .where((e) =>
                          session.isPatron || e['id'] == session.id.value)
                      .map((e) => DropdownMenuItem<String>(
                            value: e['id'],
                            child: Text(e['name']),
                          ))
                      .toList(),
                  onChanged: session.isPatron
                      ? (val) {
                          if (val != null)
                            controller.selectedEmployeeId.value = val;
                        }
                      : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Çalışan',
                  ),
                ),

                const SizedBox(height: 16),
                const Text("Hizmetler",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: controller.services.map((service) {
                      final isSelected =
                          controller.selectedServiceIds.contains(service['id']);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          label: Text(service['title']),
                          selected: isSelected,
                          onSelected: (_) {
                            if (isSelected) {
                              controller.selectedServiceIds
                                  .remove(service['id']);
                            } else {
                              controller.selectedServiceIds.add(service['id']);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                /// 📝 Not
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Not (Opsiyonel)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => controller.notes.value = val,
                ),

                const SizedBox(height: 16),

                /// 📅 Tarih ve Saat
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  title: Text(
                    controller.selectedDateTime.value == null
                        ? "Başlangıç Zamanı Seçin"
                        : DateFormat('dd.MM.yyyy – HH:mm')
                            .format(controller.selectedDateTime.value!),
                  ),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (pickedDate != null) {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        controller.selectedDateTime.value = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      } else {
                        controller.selectedDateTime.value = null;
                        CustomSnackBar.errorSnackBar(
                          title: "Saat Seçilmedi",
                          message: "Lütfen saat seçimini tamamlayın.",
                        );
                      }
                    }
                  },
                ),

                const SizedBox(height: 16),

                /// 🧮 Süre ve Ücret
                Obx(() => Text(
                      "Toplam Süre: ${controller.totalDuration} dk  •  Ücret: ₺${controller.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )),

                const SizedBox(height: 24),

                /// 🚀 Gönder Butonu
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.loading.value
                            ? null
                            : () async {
                                final success =
                                    await controller.submitAppointment();
                                if (success) {
                                  Get.find<AppointmentController>()
                                      .fetchAppointments();
                                  CustomSnackBar.successSnackBar(
                                    title: "Başarılı",
                                    message: "Randevu oluşturuldu!",
                                  );
                                  Get.back();
                                } else {
                                  CustomSnackBar.errorSnackBar(
                                    title: "Eksik Alan",
                                    message: controller
                                            .selectedCustomerId.value.isEmpty
                                        ? "Lütfen müşteri seçin."
                                        : "En az bir hizmet seçin.",
                                  );
                                }
                              },
                        child: controller.loading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                "Randevu Oluştur",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize:
                                          ProjectSizes.containerPaddingM / 1.5,
                                    ),
                              ),
                      )),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
