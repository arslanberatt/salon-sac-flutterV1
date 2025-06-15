import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';
import '../../utils/services/graphql_service.dart';

class UpdateAppointmentController extends GetxController {
  final loading = false.obs;
  final appointmentId = ''.obs;
  final appointmentStatus = ''.obs;

  // GraphQL Mutation: status ve totalPrice güncellenir
  final String updateStatusMutation = """
    mutation UpdateAppointmentStatus(\$id: ID!, \$status: String!, \$totalPrice: Float) {
      updateAppointmentStatus(id: \$id, status: \$status, totalPrice: \$totalPrice) {
        id
        status
        totalPrice
      }
    }
  """;

  Future<bool> updateAppointmentStatus(
    String id,
    String status, {
    double? price,
  }) async {
    if (appointmentStatus.value == "tamamlandi" && status == "tamamlandi") {
      CustomSnackBar.errorSnackBar(
        title: "İzin Verilmedi",
        message: "Bu randevu zaten onaylandı ve tekrar güncellenemez.",
      );
      return false;
    }

    loading.value = true;
    final client = GraphQLService.client.value;

    try {
      print(
          "🟢 Mutation Gönderiliyor -> ID: $id, Status: $status, Price: $price");

      final result = await client.mutate(MutationOptions(
        document: gql(updateStatusMutation),
        variables: {
          "id": id,
          "status": status,
          "totalPrice": price ?? 0.0,
        },
      ));

      // ❌ GraphQL hatası varsa bildir
      if (result.hasException) {
        print("❌ GraphQL Hatası: ${result.exception}");
        CustomSnackBar.errorSnackBar(
          title: "Hata",
          message: result.exception!.graphqlErrors.isNotEmpty
              ? result.exception!.graphqlErrors.first.message
              : "Randevu güncellenemedi.",
        );
        return false;
      }

      final updated = result.data?["updateAppointmentStatus"];

      // ❌ Sunucudan cevap alınamazsa
      if (updated == null) {
        CustomSnackBar.errorSnackBar(
          title: "Hata",
          message: "Sunucudan beklenen cevap alınamadı.",
        );
        return false;
      }

      // ✅ Başarıyla güncellendi
      appointmentStatus.value = updated["status"];
      appointmentId.value = updated["id"];

      CustomSnackBar.successSnackBar(
        title: "Başarılı",
        message: "Randevu '${updated["status"]}' olarak işaretlendi.",
      );

      return true;
    } catch (e) {
      // ❌ Hata durumunda log ve kullanıcıya mesaj
      print("❌ updateAppointmentStatus exception: $e");
      CustomSnackBar.errorSnackBar(
        title: "Hata",
        message: "Bir hata oluştu: $e",
      );
      return false;
    } finally {
      loading.value = false;
    }
  }
}
