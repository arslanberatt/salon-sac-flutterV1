import 'package:get/get.dart';
import 'package:mobil/controllers/appointments/appointment_controller.dart';

class PerformanceController extends GetxController {
  final currentMonthStats = <Map<String, dynamic>>[].obs;
  final topPerformerName = ''.obs;
  final topPerformerCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    computeThisMonthStats();
  }

  void computeThisMonthStats() {
    final apptCtrl = Get.find<AppointmentController>();
    final now = DateTime.now();

    final thisMonthAppointments = apptCtrl.appointments.where((appt) {
      final dt =
          DateTime.fromMillisecondsSinceEpoch(int.parse(appt['startTime']));
      return dt.year == now.year && dt.month == now.month;
    });

    final stats = <String, int>{};

    for (var appt in thisMonthAppointments) {
      final empId = appt['employeeId'];
      stats[empId] = (stats[empId] ?? 0) + 1;
    }

    final list = stats.entries.map((entry) {
      return {
        'name': apptCtrl.getEmployeeName(entry.key),
        'count': entry.value,
      };
    }).toList();

    list.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

    currentMonthStats.assignAll(list);

    if (list.isNotEmpty) {
      topPerformerName.value = list.first['name'] as String;
      topPerformerCount.value = list.first['count'] as int;
    }
  }
}
