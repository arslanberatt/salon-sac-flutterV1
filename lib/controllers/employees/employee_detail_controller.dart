import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../utils/services/graphql_service.dart';

class EmployeeDetailController extends GetxController {
  final String id;
  final name = ''.obs;
  final phone = ''.obs;

  final salaryController = TextEditingController();
  final commissionController = TextEditingController();
  final advanceController = TextEditingController();
  final passwordController = TextEditingController();
  final role = ''.obs;

  final isSaving = false.obs;

  EmployeeDetailController({required Map<String, dynamic> employee})
      : id = employee["id"] {
    name.value = employee["name"];
    phone.value = employee["phone"];
    salaryController.text = employee["salary"].toString();
    commissionController.text = employee["commissionRate"].toString();
    advanceController.text = employee["advanceBalance"].toString();
    role.value = employee["role"];
  }

  final String updateMutation = """
    mutation UpdateEmployeeByPatron(
      \$id: ID!,
      \$salary: Float,
      \$commissionRate: Float,
      \$advanceBalance: Float,
      \$password: String!
    ) {
      updateEmployeeByPatron(
        id: \$id,
        salary: \$salary,
        commissionRate: \$commissionRate,
        advanceBalance: \$advanceBalance,
        password: \$password
      ) {
        id
        name
      }
    }
  """;

  Future<void> updateEmployee() async {
    final client = GraphQLService.client.value;

    isSaving.value = true;

    try {
      final result = await client.mutate(MutationOptions(
        fetchPolicy: FetchPolicy.noCache,
        document: gql(updateMutation),
        variables: {
          "id": id,
          "salary": double.tryParse(salaryController.text) ?? 0,
          "commissionRate": double.tryParse(commissionController.text) ?? 0,
          "advanceBalance": double.tryParse(advanceController.text) ?? 0,
          "password": passwordController.text,
        },
      ));

      if (result.hasException) {
        throw result.exception!;
      }

      Get.snackbar("Başarılı", "Çalışan güncellendi");
      Get.back();
    } catch (e) {
      Get.snackbar("Hata", "Güncelleme başarısız: $e");
      print("❌ Güncelleme hatası: $e");
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    salaryController.dispose();
    commissionController.dispose();
    advanceController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
