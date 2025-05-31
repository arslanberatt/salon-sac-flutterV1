import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobil/core/core/user_session_controller.dart';
import '../../utils/services/graphql_service.dart';

class EmployeeSalaryController extends GetxController {
  final loading = false.obs;
  final employeeSalary = 0.0.obs;
  final totalAdvance = 0.0.obs;
  final totalBonus = 0.0.obs;
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
      /// 1. Maaş bilgisini çek
      final employeeResult = await client.query(QueryOptions(
        document: gql(employeeQuery),
        variables: {"id": employeeId},
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (!employeeResult.hasException) {
        final salary = employeeResult.data?['employee']?['salary'];
        employeeSalary.value = (salary ?? 0).toDouble();
        print("💰 Brüt Maaş: ${employeeSalary.value}");
      } else {
        print("❌ Çalışan maaş sorgusu hatası: ${employeeResult.exception}");
      }

      /// 2. Salary record'ları çek
      final salaryResult = await client.query(QueryOptions(
        document: gql(salaryRecordsQuery),
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (!salaryResult.hasException) {
        final records = List<Map<String, dynamic>>.from(
          salaryResult.data?['salaryRecords'] ?? [],
        );

        print("📦 Tüm Salary Record Verileri:");
        for (var e in records) {
          print("🧾 ID: ${e['id']}, EmployeeID: ${e['employeeId']}, Type: ${e['type']}, Amount: ${e['amount']}, Approved: ${e['approved']}, Desc: ${e['description']}, Date: ${e['date']}");
        }

        /// Sadece bu çalışana ait kayıtlar
        final myRecords = records.where((e) => e['employeeId'] == employeeId).toList();

        /// ✅ Avans hesapla
        final myAdvances = myRecords.where((e) {
          final type = (e['type'] ?? '').toString().toLowerCase();
          return type == 'avans' && e['approved'] == true;
        }).toList();

        final advanceTotal = myAdvances.fold(0.0, (sum, e) => sum + (e['amount'] ?? 0.0));
        totalAdvance.value = advanceTotal;
        print("✅ Avans Toplamı: $advanceTotal");

        /// ✅ Prim hesapla
        final myBonuses = myRecords.where((e) {
          final type = (e['type'] ?? '').toString().toLowerCase();
          return type == 'prim' && e['approved'] == true;
        }).toList();

        final bonusTotal = myBonuses.fold(0.0, (sum, e) => sum + (e['amount'] ?? 0.0));
        totalBonus.value = bonusTotal;
        print("✅ Prim Toplamı: $bonusTotal");

        /// 📊 Net maaş = maaş - avans + prim
        netSalary.value = employeeSalary.value - totalAdvance.value + totalBonus.value;
        print("📊 Net Maaş: ₺${netSalary.value}");
      } else {
        print("❌ Salary record sorgusu hatası: ${salaryResult.exception}");
      }
    } catch (e) {
      print("❌ Beklenmeyen hata: $e");
    } finally {
      loading.value = false;
    }
  }
}
