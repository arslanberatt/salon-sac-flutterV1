import 'package:mobil/utils/services/graphql_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';

class RequestAdvanceController extends GetxController {
  final amountController = TextEditingController();
  final reasonController = TextEditingController();
  final isSaving = false.obs;

  final String createMutation = """
    mutation CreateAdvanceRequest(\$amount: Float!, \$reason: String) {
      createAdvanceRequest(amount: \$amount, reason: \$reason) {
        id
        status
      }
    }
  """;

  Future<void> submit() async {
    final client = GraphQLService.client.value;
    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      CustomSnackBar.errorSnackBar(
          title: "Hatalı İşlem!", message: "Lütfen geçerli bir tutar giriniz.");
      return;
    }

    isSaving.value = true;

    try {
      final result = await client.mutate(MutationOptions(
        document: gql(createMutation),
        variables: {
          "amount": amount,
          "reason": reasonController.text.trim(),
        },
      ));

      if (result.hasException) {
        CustomSnackBar.errorSnackBar(
            title: "Hata", message: "Bir şeyler yanlış gitti.");
      } else {
        CustomSnackBar.successSnackBar(
            title: "Başarılı İşlem!",
            message: "Avans istemi başarı ile gerçekleşti.");
        amountController.clear();
        reasonController.clear();
      }
    } catch (e) {
      CustomSnackBar.errorSnackBar(
          title: "Hata", message: "Bir şeyler yanlış gitti.");
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    reasonController.dispose();
    super.onClose();
  }
}
