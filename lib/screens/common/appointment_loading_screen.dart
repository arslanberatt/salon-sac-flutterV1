import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:mobil/core/core/user_session_controller.dart';
import 'package:mobil/core/appointments/appointment_controller.dart';
import 'package:mobil/core/employees/employees_controller.dart';

class AppointmentLoadingScreen extends StatelessWidget {
  const AppointmentLoadingScreen({super.key});

  Future<void> loadDataAndRedirect() async {
    final session = Get.find<UserSessionController>();

    // 👤 Geçici olarak kullanıcı rolünü patron olarak ayarlayalım (eğer dışarıdan gelmiyorsa)
    if (session.role.value.isEmpty) {
      session.setUser(
        userId: "temporary",
        userRole: "calisan",
      );
      Get.snackbar("Hata", "Veriler yüklenemedi");
      return;
    }

    try {
      await Future.wait([
        Get.put(EmployeesController()).fetchEmployees(),
        Get.put(AppointmentController()).fetchAppointments(),
      ] as Iterable<Future>);

      Get.offAllNamed('/main');
    } catch (e) {
      print("❌ Yükleme hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadDataAndRedirect());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          "assets/animations/appointment.json",
          width: 160,
          height: 160,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
