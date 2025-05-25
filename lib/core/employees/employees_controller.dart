import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';
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

  final String salaryRecordsQuery = """
    query {
      salaryRecords {
        employeeId
        type
        amount
        date
      }
    }
  """;

  Future<void> fetchEmployees() async {
    loading.value = true;
    final client = GraphQLService.client.value;

    try {
      // 1. Verileri çek
      final empResult = await client.query(QueryOptions(
        document: gql(employeesQuery),
        fetchPolicy: FetchPolicy.noCache,
      ));

      final salResult = await client.query(QueryOptions(
        document: gql(salaryRecordsQuery),
        fetchPolicy: FetchPolicy.noCache,
      ));

      // 🔍 Hataları yazdır
      if (empResult.hasException) {
        CustomSnackBar.errorSnackBar(
            title: "Çalışanlar sorgusu hatası",
            message: empResult.exception.toString());
      }

      if (salResult.hasException) {
        CustomSnackBar.errorSnackBar(
            title: "Maaş kayıtları sorgusu hatası",
            message: salResult.exception.toString());
      }

      // 🔴 Eğer herhangi birinde hata varsa fırlat
      if (empResult.hasException || salResult.hasException) {
        throw empResult.exception ?? salResult.exception!;
      }

      // 2. Gelen veriyi işle
      final empList =
          List<Map<String, dynamic>>.from(empResult.data?["employees"] ?? []);
      final salaryRecords = List<Map<String, dynamic>>.from(
          salResult.data?["salaryRecords"] ?? []);

      // 3. Bu ayın kayıtlarını filtrele
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final filteredRecords = salaryRecords.where((record) {
        final dateRaw = record["date"];
        late DateTime date;

        // 🔐 Güvenli dönüşüm
        if (dateRaw is int) {
          date = DateTime.fromMillisecondsSinceEpoch(dateRaw);
        } else if (dateRaw is String) {
          final maybeInt = int.tryParse(dateRaw);
          if (maybeInt != null) {
            date = DateTime.fromMillisecondsSinceEpoch(maybeInt);
          } else {
            date = DateTime.tryParse(dateRaw) ?? DateTime(2000);
          }
        } else {
          // Geçersiz format varsa 2000 yılını ata
          date = DateTime(2000);
        }

        return date
                .isAfter(startOfMonth.subtract(const Duration(seconds: 1))) &&
            date.isBefore(endOfMonth.add(const Duration(days: 1)));
      });

      // 4. Çalışan başına prim/avans topla
      final updatedEmployees = empList.map((employee) {
        final userId = employee["id"];
        final userRecords =
            filteredRecords.where((r) => r["employeeId"] == userId);

        final monthlyBonus = userRecords
            .where((r) => r["type"] == "prim")
            .fold<double>(0, (sum, r) => sum + (r["amount"] as num).toDouble());

        final monthlyAdvance = userRecords
            .where((r) => r["type"] == "avans")
            .fold<double>(0, (sum, r) => sum + (r["amount"] as num).toDouble());

        return {
          ...employee,
          "monthlyBonus": monthlyBonus,
          "monthlyAdvance": monthlyAdvance,
          "netThisMonth": employee["salary"] + monthlyBonus - monthlyAdvance,
        };
      }).toList();

      employees.value = updatedEmployees;
    } catch (e, stacktrace) {
      print("❌ fetchEmployees() exception: $e");
      print("📍Stacktrace: $stacktrace");
      CustomSnackBar.errorSnackBar(
          title: "Hata", message: "Çalışanlar veya maaş kayıtları yüklenemedi");
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
