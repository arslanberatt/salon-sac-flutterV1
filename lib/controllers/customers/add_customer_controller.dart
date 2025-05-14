import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../utils/services/graphql_service.dart';

class AddCustomerController extends GetxController {
  // Form ve kontroller
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final notesController = TextEditingController();
  final isSaving = false.obs;

  // GraphQL mutation
  final String addCustomerMutation = """
    mutation AddCustomer(\$name: String!, \$phone: String!, \$notes: String) {
      addCustomer(name: \$name, phone: \$phone, notes: \$notes) {
        id
        name
      }
    }
  """;

  /// Müşteri ekleme işlemi
  Future<void> addCustomer() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final notes = notesController.text.trim();

    // Ön kontrol
    if (name.isEmpty || phone.isEmpty) {
      Get.snackbar("Hata", "Ad ve telefon alanları zorunludur.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSaving.value = true;

    try {
      final client = GraphQLService.client.value;

      final result = await client.mutate(MutationOptions(
        document: gql(addCustomerMutation),
        variables: {
          "name": name,
          "phone": phone,
          "notes": notes.isEmpty ? null : notes,
        },
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        throw result.exception!;
      }

      Get.snackbar("Başarılı", "Müşteri başarıyla eklendi.",
          snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed("/main");
    } catch (e) {
      Get.snackbar("Hata", "Ekleme sırasında bir sorun oluştu.",
          snackPosition: SnackPosition.BOTTOM);
      print("❌ Müşteri ekleme hatası: $e");
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
