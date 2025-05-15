import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import '../../utils/services/graphql_service.dart';
import '../core/user_session_controller.dart';

class AppointmentController extends GetxController {
  final session = Get.find<UserSessionController>();
  final appointments = <Map<String, dynamic>>[].obs;
  final employees = <Map<String, dynamic>>[].obs;
  final customers = <Map<String, dynamic>>[].obs;
  final loading = false.obs;
  final selectedDate = DateTime.now().obs;
  final waitingAppointments = 0.obs;

  final String appointmentsQuery = """
    query {
      appointments {
        id
        startTime
        endTime
        status
        notes
        employeeId
        customerId
      }
    }
  """;

  final String employeesQuery = """
    query {
      employees {
        id
        name
      }
    }
  """;
  final String customersQuery = """
    query {
      customers {
        id
        name
        phone
        notes
        createdAt
      }
    }
  """;

  void fetchAppointments() async {
    loading.value = true;
    final client = GraphQLService.client.value;
    final session = Get.find<UserSessionController>();

    try {
      final appointmentResult = await client.query(
        QueryOptions(
            document: gql(appointmentsQuery), fetchPolicy: FetchPolicy.noCache),
      );

      final employeeResult = await client.query(
        QueryOptions(
            document: gql(employeesQuery), fetchPolicy: FetchPolicy.noCache),
      );

      final customerResult = await client.query(
        QueryOptions(
            document: gql(customersQuery), fetchPolicy: FetchPolicy.noCache),
      );

      if (appointmentResult.hasException) {
        print("❌ Appointment query hatası: ${appointmentResult.exception}");
        return;
      }

      if (employeeResult.hasException) {
        print("❌ Employee query hatası: ${employeeResult.exception}");
        return;
      }

      if (customerResult.hasException) {
        print("❌ Customer query hatası: ${customerResult.exception}");
        return;
      }

      final allAppointments = List<Map<String, dynamic>>.from(
        appointmentResult.data!['appointments'],
      );

      final allEmployees =
          List<Map<String, dynamic>>.from(employeeResult.data!['employees']);

      final allCustomers =
          List<Map<String, dynamic>>.from(customerResult.data!['customers']);

      customers.value = allCustomers;
      employees.value = allEmployees;

      if (session.isPatron) {
        print("🟢 Patron giriş yaptı");
        appointments.value = allAppointments;
        waitingAppointments.value = allAppointments
            .where((appt) => appt["status"] == "bekliyor")
            .length;
      } else if (session.isEmployee) {
        print("🟢 Çalışan giriş yaptı");
        appointments.value = allAppointments
            .where((a) => a["employeeId"] == session.id.value)
            .toList();
        waitingAppointments.value = allAppointments
            .where((appt) => appt["status"] == "bekliyor")
            .where((a) => a["employeeId"] == session.id.value)
            .length;
      } else {
        print("🟢 Bilinmeyen giriş yaptı");
        appointments.clear();
      }

      print("🟢 Randevular çekildi: ${appointments.length} kayıt");
    } catch (e) {
      print("❌ Veri çekme hatası: $e");
    } finally {
      loading.value = false;
    }
  }

  String getEmployeeName(String employeeId) {
    return employees.firstWhereOrNull((e) => e['id'] == employeeId)?['name'] ??
        'Bilinmiyor';
  }

  String getCustomerName(String customerId) {
    return customers.firstWhereOrNull((e) => e['id'] == customerId)?['name'] ??
        'Bilinmiyor';
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  List<Map<String, dynamic>> get filteredAppointments {
    final selected = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
    );

    return appointments.where((appt) {
      final apptDate =
          DateTime.fromMillisecondsSinceEpoch(int.parse(appt['startTime']))
              .toLocal();

      final isSameDay = apptDate.year == selected.year &&
          apptDate.month == selected.month &&
          apptDate.day == selected.day;

      return isSameDay;
    }).toList();
  }

  String formatTime(dynamic timestamp) {
    try {
      final dt = timestamp is int
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));

      return DateFormat.Hm().format(dt.toLocal());
    } catch (_) {
      return "-";
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  String calculateDuration(dynamic start, dynamic end) {
    try {
      final startTime = start is int
          ? DateTime.fromMillisecondsSinceEpoch(start)
          : DateTime.fromMillisecondsSinceEpoch(int.parse(start));
      final endTime = end is int
          ? DateTime.fromMillisecondsSinceEpoch(end)
          : DateTime.fromMillisecondsSinceEpoch(int.parse(end));

      final diff = endTime.difference(startTime);
      return "${diff.inHours} saat ${diff.inMinutes % 60} dk";
    } catch (_) {
      return "-";
    }
  }
}
