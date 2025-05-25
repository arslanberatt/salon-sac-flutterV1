import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';
import '../../utils/services/graphql_service.dart';

class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final isSaving = false.obs;

  final String updateMutation = """
    mutation UpdateMyInfo(\$name: String, \$phone: String, \$password: String) {
      updateMyInfo(name: \$name, phone: \$phone, password: \$password) {
        id
        name
        phone
      }
    }
  """;

  Future<void> updateProfile() async {
    isSaving.value = true;
    final client = GraphQLService.client.value;

    try {
      final result = await client.mutate(MutationOptions(
        document: gql(updateMutation),
        variables: {
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
          "password": passwordController.text.trim().isEmpty
              ? null
              : passwordController.text.trim(),
        },
      ));

      if (result.hasException) {
        CustomSnackBar.errorSnackBar(
            title: "Hata", message: result.exception.toString());
      } else {
        CustomSnackBar.successSnackBar(
            title: "Başarılı", message: "Profil güncellendi");
        passwordController.clear();
      }
    } catch (e) {
      CustomSnackBar.errorSnackBar(title: "Hata", message: e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
