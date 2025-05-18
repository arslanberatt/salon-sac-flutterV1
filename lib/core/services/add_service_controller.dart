import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';
import '../../utils/services/graphql_service.dart';
import 'service_controller.dart';

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
    final title = titleController.text.trim();
    final duration = int.tryParse(durationController.text.trim());
    final price = double.tryParse(priceController.text.trim());

    if (title.isEmpty || duration == null || price == null) {
      CustomSnackBar.errorSnackBar(
        title: "Hata",
        message: "Tüm alanları eksiksiz ve doğru doldurun",
      );
      return;
    }

    isSaving.value = true;

    final client = GraphQLService.client.value;
    final result = await client.mutate(MutationOptions(
      document: gql(addServiceMutation),
      variables: {
        "title": title,
        "duration": duration,
        "price": price,
      },
      fetchPolicy: FetchPolicy.noCache,
    ));

    isSaving.value = false;

    if (result.hasException) {
      CustomSnackBar.errorSnackBar(
        title: "Hata",
        message: "Ekleme başarısız: ${result.exception.toString()}",
      );
      return;
    }

    // Başarıyla eklendiyse listeyi güncelle
    if (Get.isRegistered<ServiceController>()) {
      Get.find<ServiceController>().fetchServices();
    }

    // Formu temizle
    titleController.clear();
    durationController.clear();
    priceController.clear();

    CustomSnackBar.successSnackBar(
      title: "Başarılı",
      message: "Hizmet başarıyla eklendi",
    );
  }

  @override
  void onClose() {
    titleController.dispose();
    durationController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
