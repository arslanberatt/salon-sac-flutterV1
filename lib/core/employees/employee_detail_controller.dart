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

  final String updateFinanceMutation = """
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

  final String updateRoleMutation = """
    mutation UpdateEmployeeRole(
      \$id: ID!,
      \$role: String!,
      \$password: String!
    ) {
      updateEmployeeRole(id: \$id, role: \$role, password: \$password) {
        id
        role
      }
    }
  """;

  Future<void> updateEmployee() async {
    if (passwordController.text.trim().isEmpty) {
      Get.snackbar("Hata", "Lütfen onay şifresi girin");
      return;
    }

    isSaving.value = true;
    final client = GraphQLService.client.value;

    try {
      final financeResult = await client.mutate(MutationOptions(
        document: gql(updateFinanceMutation),
        fetchPolicy: FetchPolicy.noCache,
        onCompleted: (data) {
          if (data != null) {
            Get.back(result: true);
          }
        },
        variables: {
          "id": id,
          "salary": double.tryParse(salaryController.text) ?? 0,
          "commissionRate": double.tryParse(commissionController.text) ?? 0,
          "advanceBalance": double.tryParse(advanceController.text) ?? 0,
          "password": passwordController.text,
        },
      ));

      if (financeResult.hasException) {
        throw financeResult.exception!;
      }

      final roleResult = await client.mutate(MutationOptions(
        document: gql(updateRoleMutation),
        variables: {
          "id": id,
          "role": role.value,
          "password": passwordController.text,
        },
      ));

      if (roleResult.hasException) {
        throw roleResult.exception!;
      }
      isSaving.value
          ? null
          : Get.snackbar("Başarılı", "Çalışan başarıyla güncellendi");
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
