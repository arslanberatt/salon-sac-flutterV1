import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobil/screens/appointments/appointment_detail_modal.dart';
import 'package:mobil/utils/constants/sizes.dart';

class AppointmentCard extends StatelessWidget {
  final String title;
  final String customer;
  final String checkIn;
  final String checkOut;
  final String duration;
  final String appointmentId;
  final List<Map<String, dynamic>> services;
  final String status;
  final String notes;

  const AppointmentCard({
    super.key,
    required this.title,
    required this.customer,
    required this.checkIn,
    required this.checkOut,
    required this.duration,
    required this.appointmentId,
    required this.services,
    required this.status,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.lightBlue;
    if (status == 'iptal') statusColor = Colors.red;
    if (status == 'tamamlandi') statusColor = Colors.green;

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
        status: status,
        notes: notes,
      ),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ProjectSizes.containerPaddingS),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık ve durum
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Iconsax.timer, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          duration,
                          style: TextStyle(
                            fontSize: 12,
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
                children: const [
                  Text("Tahmini Giriş", style: TextStyle(color: Colors.grey)),
                  Icon(Iconsax.arrow_swap_horizontal, color: Colors.grey),
                  Text("Tahmini Çıkış", style: TextStyle(color: Colors.grey)),
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
