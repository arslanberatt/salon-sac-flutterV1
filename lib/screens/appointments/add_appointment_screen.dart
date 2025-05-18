import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:mobil/core/appointments/appointment_controller.dart';
import 'package:mobil/screens/common/appointment_loading_screen.dart';
import 'package:mobil/utils/constants/sizes.dart';
import '../../core/appointments/add_appointment_controller.dart';

class AddAppointmentScreen extends StatelessWidget {
  const AddAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddAppointmentController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Randevu Ekle",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Domine',
          ),
        ),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: AppointmentLoadingScreen());
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
                  suggestionsCallback: (pattern) {
                    return controller.customers
                        .where((c) => c['name']
                            .toString()
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(title: Text(suggestion['name']));
                  },
                  onSuggestionSelected: (suggestion) {
                    controller.selectedCustomerId.value = suggestion['id'];
                    controller.customerNameController.text = suggestion['name'];
                  },
                ),

                const SizedBox(height: 16),

                /// 👤 Çalışan Seçimi
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: "Çalışan Seçin",
                    border: OutlineInputBorder(),
                  ),
                  value: controller.selectedEmployeeId.value.isEmpty
                      ? null
                      : controller.selectedEmployeeId.value,
                  items: controller.employees
                      .map((e) => DropdownMenuItem(
                            value: e['id'],
                            child: Text(e['name']),
                          ))
                      .toList(),
                  onChanged: (val) =>
                      controller.selectedEmployeeId.value = val as String,
                ),

                const SizedBox(height: 16),

                /// 💇 Hizmet Seçimi
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

                /// 📝 Notlar
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Not (Opsiyonel)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => controller.notes.value = val,
                  maxLines: 2,
                ),

                const SizedBox(height: 16),

                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  title: Text(
                    controller.selectedDateTime.value == null
                        ? "Başlangıç Zamanı Seçin"
                        : controller.selectedDateTime.value.toString(),
                  ),
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
                        final dateTime = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          time.hour,
                          time.minute,
                        );
                        controller.selectedDateTime.value = dateTime;
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
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        onPressed: controller.loading.value
                            ? null
                            : () async {
                                final success =
                                    await controller.submitAppointment();
                                if (success) {
                                  final appointmentController =
                                      Get.isRegistered<AppointmentController>()
                                          ? Get.find<AppointmentController>()
                                          : null;
                                  appointmentController?.fetchAppointments();
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
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
