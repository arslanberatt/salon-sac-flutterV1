import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';
import '../../utils/services/graphql_service.dart';

class EditAppointmentController extends GetxController {
  final loading = false.obs;
  final appointmentId = ''.obs;
  final appointmentStatus = ''.obs;

  final String updateStatusMutation = """
    mutation UpdateAppointmentStatus(\$id: ID!, \$status: String!) {
      updateAppointmentStatus(id: \$id, status: \$status) {
        id
        status
      }
    }
  """;

  Future<bool> updateAppointmentStatus(String id, String status) async {
    loading.value = true;
    final client = GraphQLService.client.value;

    try {
      final result = await client.mutate(MutationOptions(
        document: gql(updateStatusMutation),
        variables: {
          "id": id,
          "status": status,
        },
      ));

      if (result.hasException) {
        print("❌ Durum güncelleme hatası: ${result.exception}");
        CustomSnackBar.errorSnackBar(
            title: "Hata", message: "Randevu güncellenemedi.");
        return false;
      }

      appointmentStatus.value = status;
      return true;
    } catch (e) {
      print("❌ updateAppointmentStatus error: $e");
      return false;
    } finally {
      loading.value = false;
    }
  }
}
