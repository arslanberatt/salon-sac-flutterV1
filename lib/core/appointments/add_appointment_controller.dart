import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobil/core/appointments/appointment_controller.dart';
import 'package:mobil/core/core/user_session_controller.dart';
import 'package:mobil/utils/services/graphql_service.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';

class AddAppointmentController extends GetxController {
  /// --- UI Kontrolleri ---
  final customerNameController = TextEditingController();
  final customerFocusNode = FocusNode();

  /// --- Data listeleri ---
  final customers = <Map<String, dynamic>>[].obs;
  final employees = <Map<String, dynamic>>[].obs;
  final services = <Map<String, dynamic>>[].obs;

  /// --- Seçimler ---
  final selectedCustomerId = ''.obs;
  final selectedEmployeeId = ''.obs;
  final selectedServiceIds = <String>[].obs;
  final selectedDateTime = Rxn<DateTime>();
  final notes = ''.obs;
  final loading = false.obs;

  /// --- GraphQL Mutasyonu ---
  final String addAppointmentMutation = """
    mutation AddAppointment(
      \$customerId: ID!
      \$employeeId: ID!
      \$serviceIds: [ID!]!
      \$startTime: String!
      \$totalPrice: Float!
      \$notes: String
    ) {
      addAppointment(
        customerId: \$customerId
        employeeId: \$employeeId
        serviceIds: \$serviceIds
        startTime: \$startTime
        totalPrice: \$totalPrice
        notes: \$notes
      ) {
        id
      }
    }
  """;

  /// --- Hesaplamalar ---
  double get totalPrice => services
      .where((s) => selectedServiceIds.contains(s['id']))
      .fold(0.0, (sum, item) => sum + (item['price'] as num).toDouble());

  int get totalDuration => services
      .where((s) => selectedServiceIds.contains(s['id']))
      .fold(0, (sum, item) => sum + (item['duration'] as int));

  /// --- Tüm verileri çek ---
  Future<void> fetchAllData() async {
    loading.value = true;
    final client = GraphQLService.client.value;

    try {
      final results = await Future.wait([
        client.query(
            QueryOptions(document: gql("""query { customers { id name } }"""))),
        client.query(QueryOptions(
            document:
                gql("""query { services { id title duration price } }"""))),
      ]);

      customers.value =
          List<Map<String, dynamic>>.from(results[0].data?['customers'] ?? []);
      services.value =
          List<Map<String, dynamic>>.from(results[1].data?['services'] ?? []);
    } catch (e) {
      print("❌ Veri çekme hatası: $e");
    } finally {
      loading.value = false;
    }
  }

  /// --- Çakışma ve günlük randevu kontrolü ---
  Future<bool> hasConflictOrDuplicate() async {
    final client = GraphQLService.client.value;
    final start = selectedDateTime.value!;
    final end = start.add(Duration(minutes: totalDuration));

    final result = await client.query(QueryOptions(
      document: gql(
          """query { appointments { employeeId customerId startTime endTime status } }"""),
    ));

    final appointments =
        List<Map<String, dynamic>>.from(result.data?['appointments'] ?? [])
            .where((a) => a['status'] == 'bekliyor')
            .toList();

    final conflict = appointments.any((a) {
      if (a['employeeId'] != selectedEmployeeId.value) return false;
      final aStart = DateTime.parse(a['startTime']).toUtc();
      final aEnd = DateTime.parse(a['endTime']).toUtc();
      return start.toUtc().isBefore(aEnd) && start.toUtc().isAfter(aStart);
    });

    if (conflict) {
      CustomSnackBar.errorSnackBar(
        title: "Çalışan Meşgul",
        message: "Seçilen saatte başka bir randevusu var.",
      );
      return true;
    }

    final sameDay = appointments.any((a) {
      if (a['customerId'] != selectedCustomerId.value) return false;
      final aStart = DateTime.parse(a['startTime']).toUtc();
      return aStart.year == start.year &&
          aStart.month == start.month &&
          aStart.day == start.day;
    });

    if (sameDay) {
      CustomSnackBar.errorSnackBar(
        title: "Zaten Randevulu",
        message: "Bu müşteriye o gün zaten randevu alınmış.",
      );
      return true;
    }

    return false;
  }

  /// --- Randevu oluştur ---
  Future<bool> submitAppointment() async {
    if (selectedCustomerId.isEmpty ||
        selectedServiceIds.isEmpty ||
        selectedDateTime.value == null) {
      CustomSnackBar.errorSnackBar(
          title: "Eksik Bilgi", message: "Tüm alanları doldurun.");
      return false;
    }

    loading.value = true;
    final client = GraphQLService.client.value;

    try {
      final result = await client.mutate(MutationOptions(
        document: gql(addAppointmentMutation),
        variables: {
          'customerId': selectedCustomerId.value,
          'employeeId': selectedEmployeeId.value,
          'serviceIds': selectedServiceIds,
          'startTime': selectedDateTime.value!.toUtc().toIso8601String(),
          'totalPrice': totalPrice,
          'notes': notes.value.isEmpty ? null : notes.value,
        },
      ));

      if (result.hasException) {
        final errorMsg = result.exception?.graphqlErrors.firstOrNull?.message ??
            "Randevu oluşturulamadı.";

        if (errorMsg.contains("başka bir randevusu var")) {
          CustomSnackBar.errorSnackBar(
            title: "Çakışan Randevu",
            message:
                "Bu çalışanın seçilen saat aralığında başka bir randevusu var.",
          );
        } else if (errorMsg.contains("zaten bir randevu alınmış")) {
          CustomSnackBar.errorSnackBar(
            title: "Tekrarlayan Randevu",
            message:
                "Bu müşteriye o gün zaten bir randevu alınmış. İkinci kez ekleyemezsiniz.",
          );
        } else {
          CustomSnackBar.errorSnackBar(
            title: "Sunucu Hatası",
            message: errorMsg,
          );
        }

        return false;
      }

      CustomSnackBar.successSnackBar(
          title: "Başarılı", message: "Randevu oluşturuldu.");
      Get.find<AppointmentController>().fetchAppointments(); // otomatik yenile
      Get.back();
      return true;
    } catch (e) {
      print("❌ Submit error: $e");
      CustomSnackBar.errorSnackBar(
        title: "Hata",
        message: "Randevu gönderimi sırasında bir hata oluştu.",
      );
      return false;
    } finally {
      loading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
    final session = Get.find<UserSessionController>();
    selectedEmployeeId.value = session.id.value; // 🔒 Sabit çalışan ID
  }

  @override
  void onClose() {
    customerNameController.dispose();
    customerFocusNode.dispose();
    super.onClose();
  }
}
