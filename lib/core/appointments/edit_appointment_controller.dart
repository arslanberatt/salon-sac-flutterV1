import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../utils/services/graphql_service.dart';
import '../../utils/theme/widget_themes/custom_snackbar.dart';

class EditAppointmentController extends GetxController {
  final loading = false.obs;
  final notesController = TextEditingController();
  final selectedDateTime = Rxn<DateTime>();

  String? appointmentId;
  List<String> serviceIds = [];
  List<Map<String, dynamic>> allServices = [];

  /// Get appointment data
  Future<void> loadAppointment(String id) async {
    loading.value = true;
    appointmentId = id;

    try {
      final client = GraphQLService.client.value;

      final result = await client.query(QueryOptions(
        document: gql("""
          query GetAppointment(\$id: ID!) {
            appointment(id: \$id) {
              id
              startTime
              notes
              serviceIds
            }
          }
        """),
        variables: {"id": id},
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        CustomSnackBar.errorSnackBar(
          title: "Hata",
          message: result.exception.toString(),
        );
        return;
      }

      final data = result.data?['appointment'];
      if (data == null) {
        CustomSnackBar.errorSnackBar(
          title: "Hata",
          message: "Randevu bulunamadı.",
        );
        return;
      }

      selectedDateTime.value =
          DateTime.tryParse(data['startTime'] ?? '')?.toLocal();
      notesController.text = data['notes'] ?? '';
      serviceIds = List<String>.from(data['serviceIds'] ?? []);

      await fetchAllServices();
    } catch (e) {
      CustomSnackBar.errorSnackBar(
        title: "Hata",
        message: e.toString(),
      );
    } finally {
      loading.value = false;
    }
  }

  /// Fetch all services from backend to get durations
  Future<void> fetchAllServices() async {
    final client = GraphQLService.client.value;

    try {
      final result = await client.query(QueryOptions(
        document: gql("""
          query {
            services {
              id
              title
              duration
            }
          }
        """),
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        CustomSnackBar.errorSnackBar(
          title: "Hizmet Hatası",
          message: result.exception.toString(),
        );
        return;
      }

      allServices =
          List<Map<String, dynamic>>.from(result.data?['services'] ?? []);
    } catch (e) {
      print("❌ Hizmet çekme hatası: $e");
    }
  }

  /// Toplam süreyi servislere göre hesapla
  int calculateTotalDuration() {
    int total = 0;
    for (final id in serviceIds) {
      final service = allServices.firstWhereOrNull((s) => s['id'] == id);
      if (service != null) {
        total += (service['duration'] ?? 0) as int;
      }
    }
    return total;
  }

  /// Güncelleme fonksiyonu
  Future<bool> updateAppointment() async {
    if (appointmentId == null || selectedDateTime.value == null) {
      CustomSnackBar.errorSnackBar(
        title: "Eksik Bilgi",
        message: "Başlangıç zamanı eksik.",
      );
      return false;
    }

    loading.value = true;

    try {
      final client = GraphQLService.client.value;

      final startUtc = selectedDateTime.value!.toUtc();
      final totalDuration = calculateTotalDuration();
      final endUtc = startUtc.add(Duration(minutes: totalDuration));

      final result = await client.mutate(MutationOptions(
        document: gql("""
          mutation UpdateAppointment(\$id: ID!, \$startTime: String!, \$endTime: String!, \$notes: String) {
            updateAppointment(id: \$id, startTime: \$startTime, endTime: \$endTime, notes: \$notes) {
              id
            }
          }
        """),
        variables: {
          "id": appointmentId,
          "startTime": startUtc.toIso8601String(),
          "endTime": endUtc.toIso8601String(),
          "notes": notesController.text.trim(),
        },
      ));

      if (result.hasException) {
        CustomSnackBar.errorSnackBar(
          title: "Güncelleme Hatası",
          message: result.exception.toString(),
        );
        return false;
      }

      return true;
    } catch (e) {
      CustomSnackBar.errorSnackBar(
        title: "Hata",
        message: e.toString(),
      );
      return false;
    } finally {
      loading.value = false;
    }
  }
}
