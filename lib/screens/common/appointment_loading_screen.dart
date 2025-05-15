import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:mobil/controllers/core/user_session_controller.dart';
import 'package:mobil/controllers/appointments/appointment_controller.dart';
import 'package:mobil/controllers/employees/employees_controller.dart';

class AppointmentLoadingScreen extends StatelessWidget {
  const AppointmentLoadingScreen({super.key});

  Future<void> loadDataAndRedirect() async {
    final session = Get.find<UserSessionController>();

    // 👤 Geçici olarak kullanıcı rolünü patron olarak ayarlayalım (eğer dışarıdan gelmiyorsa)
    if (session.role.value.isEmpty) {
      session.setUser(
        userId: "temporary",
        userName: "Geçici Kullanıcı",
        userRole: "calisan",
      );
      Get.snackbar("Hata", "Veriler yüklenemedi");
      return;
    }

    try {
      await Future.wait([
        Get.find<EmployeesController>().fetchEmployees(),
        Get.find<AppointmentController>().fetchAppointments(),
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
