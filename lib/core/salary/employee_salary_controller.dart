import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobil/core/core/user_session_controller.dart';
import '../../utils/services/graphql_service.dart';

class EmployeeSalaryController extends GetxController {
  final loading = false.obs;
  final employeeSalary = 0.0.obs;
  final totalAdvance = 0.0.obs;
  final netSalary = 0.0.obs;

  final userSession = Get.find<UserSessionController>();

  @override
  void onInit() {
    super.onInit();
    fetchEmployeeSalaryData();
  }

  Future<void> fetchEmployeeSalaryData() async {
    final client = GraphQLService.client.value;
    final employeeId = userSession.id.value;

    if (employeeId.isEmpty) {
      print("❌ Giriş yapan kullanıcının ID’si boş.");
      return;
    }

    loading.value = true;

    const String employeeQuery = """
      query GetEmployee(\$id: ID!) {
        employee(id: \$id) {
          id
          name
          salary
        }
      }
    """;

    const String salaryRecordsQuery = """
      query {
        salaryRecords {
          id
          employeeId
          type
          amount
          approved
          description
          date
        }
      }
    """;

    try {
      /// 1. Çalışanın maaş bilgisini çek
      final employeeResult = await client.query(QueryOptions(
        document: gql(employeeQuery),
        variables: {"id": employeeId},
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (!employeeResult.hasException) {
        final salary = employeeResult.data?['employee']?['salary'];
        employeeSalary.value = (salary ?? 0).toDouble();
      } else {
        print("❌ Çalışan maaş sorgusu hatası: ${employeeResult.exception}");
      }

      /// 2. Tüm salaryRecords çekilip filtrelenir
      final salaryResult = await client.query(QueryOptions(
        document: gql(salaryRecordsQuery),
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (!salaryResult.hasException) {
        final records = List<Map<String, dynamic>>.from(
          salaryResult.data?['salaryRecords'] ?? [],
        );

        final myRecords = records
            .where((e) =>
                e['employeeId'] == employeeId &&
                e['type'] == 'avans' &&
                e['approved'] == true)
            .toList();

        final total =
            myRecords.fold(0.0, (sum, e) => sum + (e['amount'] ?? 0.0));
        totalAdvance.value = total;
      } else {
        print("❌ Salary record sorgusu hatası: ${salaryResult.exception}");
      }

      /// 3. Net maaş hesapla
      netSalary.value = employeeSalary.value - totalAdvance.value;
    } catch (e) {
      print("❌ Beklenmeyen hata: $e");
    } finally {
      loading.value = false;
    }
  }
}
