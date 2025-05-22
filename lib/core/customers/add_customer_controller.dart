import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';
import '../../utils/services/graphql_service.dart';

class AddCustomerController extends GetxController {
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
      CustomSnackBar.errorSnackBar(
        title: "Hata",
        message: "Ad ve telefon numarası boş olamaz.",
      );
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
          onCompleted: (data) {
            // ✅ INPUT ALANLARINI TEMİZLE
            nameController.clear();
            phoneController.clear();
            notesController.clear();

            Get.back(result: true);
          },
          onError: (error) {
            CustomSnackBar.errorSnackBar(
              title: "Hata",
              message: "Müşteri eklenirken hata oluştu: ",
            );
          }));

      if (result.hasException) {
        throw result.exception!;
      }
      CustomSnackBar.successSnackBar(
          title: "İşlem Başarılı!",
          message: "Müşteri sisteme başarı ile eklendi.");
    } catch (e) {
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
