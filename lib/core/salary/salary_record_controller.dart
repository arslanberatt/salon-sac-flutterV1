import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../utils/services/graphql_service.dart';

class SalaryRecordController extends GetxController {
  final records = <Map<String, dynamic>>[].obs;
  final loading = false.obs;

  final String fetchQuery = """
    query {
      salaryRecords {
        id
        type
        amount
        description
        approved
        date
        employeeId
      }
    }
  """;

  Future<void> fetchSalaryRecords() async {
    loading.value = true;
    final client = GraphQLService.client.value;

    try {
      final result = await client.query(QueryOptions(
        document: gql(fetchQuery),
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        print("❌ SalaryRecord hatası: ${result.exception}");
        return;
      }

      records.value =
          List<Map<String, dynamic>>.from(result.data!['salaryRecords']);
    } catch (e) {
      print("❌ Hata: $e");
    } finally {
      loading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchSalaryRecords();
  }
}
