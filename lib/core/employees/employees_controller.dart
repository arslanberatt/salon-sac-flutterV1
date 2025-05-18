import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../utils/services/graphql_service.dart';

class EmployeesController extends GetxController {
  final employees = <Map<String, dynamic>>[].obs;
  final loading = false.obs;

  final String employeesQuery = """
    query {
      employees {
        id
        name
        phone
        role
        salary
        commissionRate
        advanceBalance
      }
    }
  """;

  void fetchEmployees() async {
    loading.value = true;
    final client = GraphQLService.client.value;

    try {
      final result = await client.query(QueryOptions(
        document: gql(employeesQuery),
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        throw result.exception!;
      }

      employees.value =
          List<Map<String, dynamic>>.from(result.data?["employees"] ?? []);
    } catch (e) {
      Get.snackbar("Hata", "Çalışanlar yüklenemedi");
    } finally {
      loading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }
}
