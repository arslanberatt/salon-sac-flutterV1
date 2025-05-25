import 'package:get/get.dart';
import 'package:mobil/core/appointments/add_appointment_controller.dart';
import 'package:mobil/core/appointments/appointment_controller.dart';

class AddAppointmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddAppointmentController());
    Get.lazyPut(() => AppointmentController());
  }
}
