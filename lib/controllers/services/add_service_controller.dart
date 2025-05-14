import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../utils/services/graphql_service.dart';

class AddServiceController extends GetxController {
  final titleController = TextEditingController();
  final durationController = TextEditingController();
  final priceController = TextEditingController();
  final isSaving = false.obs;

  final String addServiceMutation = """
    mutation AddService(\$title: String!, \$duration: Int!, \$price: Float!) {
      addService(title: \$title, duration: \$duration, price: \$price) {
        id
        title
      }
    }
  """;

  Future<void> submit() async {
    if (titleController.text.trim().isEmpty ||
        durationController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty) {
      Get.snackbar("Hata", "Tüm alanları doldurunuz");
      return;
    }

    final duration = int.tryParse(durationController.text.trim());
    final price = double.tryParse(priceController.text.trim());

    if (duration == null || price == null) {
      Get.snackbar("Hata", "Süre ve ücret sayısal olmalı");
      return;
    }

    isSaving.value = true;

    final client = GraphQLService.client.value;
    final result = await client.mutate(MutationOptions(
      document: gql(addServiceMutation),
      variables: {
        "title": titleController.text.trim(),
        "duration": duration,
        "price": price,
      },
      fetchPolicy: FetchPolicy.noCache,
    ));

    isSaving.value = false;

    if (result.hasException) {
      Get.snackbar("Hata", result.exception.toString());
      return;
    }

    // Listeyi güncelle (varsa)
    final serviceController = Get.isRegistered() ? Get.find() : null;

    serviceController?.fetchServices();

    Get.snackbar("Başarılı", "Hizmet eklendi");
    Get.offAllNamed('/main');
  }

  @override
  void onClose() {
    titleController.dispose();
    durationController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
