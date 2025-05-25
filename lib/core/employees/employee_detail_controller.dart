import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';
import '../../utils/services/graphql_service.dart';

class EmployeeDetailController extends GetxController {
  final String id;
  final name = ''.obs;
  final phone = ''.obs;
  final role = ''.obs;

  final salaryController = TextEditingController();
  final commissionController = TextEditingController();
  final advanceController = TextEditingController();
  final passwordController = TextEditingController();

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

  final String getEmployeeQuery = """
    query GetEmployee(\$id: ID!) {
      employee(id: \$id) {
        id
        name
        phone
        salary
        commissionRate
        advanceBalance
        role
      }
    }
  """;

  Future<void> fetchEmployeeDetails() async {
    final client = GraphQLService.client.value;

    final result = await client.query(QueryOptions(
      document: gql(getEmployeeQuery),
      variables: {"id": id},
      fetchPolicy: FetchPolicy.noCache,
    ));

    if (result.hasException) {
      print("❌ Çalışan bilgisi alınamadı: ${result.exception}");
      CustomSnackBar.errorSnackBar(
          title: "Hata", message: "Çalışan bilgisi alınamadı.");
      return;
    }

    final data = result.data?["employee"];
    if (data != null) {
      name.value = data["name"];
      phone.value = data["phone"];
      salaryController.text = data["salary"].toString();
      commissionController.text = data["commissionRate"].toString();
      advanceController.text = data["advanceBalance"].toString();
      role.value = data["role"];
    }
  }

  Future<void> updateEmployee() async {
    if (passwordController.text.trim().isEmpty) {
      CustomSnackBar.errorSnackBar(
          title: "Hata", message: "Lütfen onay şifresi girin");
      return;
    }

    isSaving.value = true;
    final client = GraphQLService.client.value;

    try {
      final financeResult = await client.mutate(MutationOptions(
        document: gql(updateFinanceMutation),
        fetchPolicy: FetchPolicy.noCache,
        variables: {
          "id": id,
          "salary": double.tryParse(salaryController.text) ?? 0,
          "commissionRate": double.tryParse(commissionController.text) ?? 0,
          "advanceBalance": double.tryParse(advanceController.text) ?? 0,
          "password": passwordController.text,
        },
        onCompleted: (data) => Get.back(result: true),
      ));

      if (financeResult.hasException) {
        throw financeResult.exception!;
      }

      final roleResult = await client.mutate(MutationOptions(
        document: gql(updateRoleMutation),
        fetchPolicy: FetchPolicy.noCache,
        variables: {
          "id": id,
          "role": role.value,
          "password": passwordController.text,
        },
      ));

      if (roleResult.hasException) {
        throw roleResult.exception!;
      }

      CustomSnackBar.successSnackBar(
          title: "Başarılı", message: "Çalışan başarıyla güncellendi");
      Get.back(result: true);
    } catch (e) {
      CustomSnackBar.errorSnackBar(
          title: "Hata", message: "Güncelleme başarısız: $e");
      print("❌ Güncelleme hatası: $e");
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchEmployeeDetails(); // Sayfa açıldığında ilk veriyi yükle
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
