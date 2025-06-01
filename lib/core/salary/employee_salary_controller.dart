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

    // Burada date alanı String olarak geliyor; sorgunun içinde yorum bırakmıyoruz.
    const String salaryRecordsQuery = """
      query {
        salaryRecords {
          id
          employeeId
          type
          amount
          approved
          date
        }
      }
    """;

    try {
      /// 1. Çalışanın brüt maaş bilgisini çek
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

      /// 2. Tüm salary record kayıtlarını çek
      final salaryResult = await client.query(QueryOptions(
        document: gql(salaryRecordsQuery),
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (!salaryResult.hasException) {
        final allRecords = List<Map<String, dynamic>>.from(
          salaryResult.data?['salaryRecords'] ?? [],
        );

        /// 3. Önce bu çalışana ait ve onaylı kayıtları filtrele
        final myRecords = allRecords.where((e) {
          return e['employeeId'] == employeeId && (e['approved'] == true);
        }).toList();

        /// İçinde bulunduğumuz aya ait kayıtları bulmak için:
        final now = DateTime.now();
        final currentMonthRecords = myRecords.where((e) {
          // date alanı String olarak geliyor, önce int'e parse edelim
          final dateString = e['date']?.toString() ?? '';
          int timestampMillis;

          try {
            timestampMillis = int.parse(dateString);
          } catch (_) {
            // Eğer parse edilemezse, bu kaydı dışarı al
            print("⚠️ Geçersiz date formatı (parse hatası): $dateString");
            return false;
          }

          final recordDate = DateTime.fromMillisecondsSinceEpoch(timestampMillis);
          // Yıl ve ay karşılaştırması
          return recordDate.year == now.year && recordDate.month == now.month;
        }).toList();

        /// 4. Şimdi “avans” ve “prim” için aylık toplamları hesapla

        // Aylık Avanslar
        final monthlyAdvances = currentMonthRecords.where((e) {
          final type = (e['type'] ?? '').toString().toLowerCase();
          return type == 'avans';
        }).toList();

        final advanceTotal = monthlyAdvances.fold<double>(
          0.0,
          (sum, e) {
            final amt = (e['amount'] as num?)?.toDouble() ?? 0.0;
            return sum + amt;
          },
        );
        totalAdvance.value = advanceTotal;
        print("✅ Bu Ayın Avans Toplamı: ₺$advanceTotal");

        // Aylık Primler
        final monthlyBonuses = currentMonthRecords.where((e) {
          final type = (e['type'] ?? '').toString().toLowerCase();
          return type == 'prim';
        }).toList();

        final bonusTotal = monthlyBonuses.fold<double>(
          0.0,
          (sum, e) {
            final amt = (e['amount'] as num?)?.toDouble() ?? 0.0;
            return sum + amt;
          },
        );
        totalBonus.value = bonusTotal;
        print("✅ Bu Ayın Prim Toplamı: ₺$bonusTotal");

        /// 5. Şimdi her bir kaydı konsola (print) yazdıralım

        print("📦 Bu Ayın Kayıtları:");
        for (var e in currentMonthRecords) {
          final id = e['id'] ?? 'ID yok';
          final type = e['type'] ?? 'type yok';
          final amount = e['amount'] ?? 0;
          final dateString = e['date']?.toString() ?? '';
          // parse edilmiş timestampMillis
          final timestampMillis = int.parse(dateString);
          final recordDate = DateTime.fromMillisecondsSinceEpoch(timestampMillis);

          print(
            "🧾 ID: $id, Type: $type, Amount: $amount, Date: $recordDate",
          );
        }

        /// 6. Net maaş = Brüt maaş – Aylık avanslar + Aylık primler
        netSalary.value =
            employeeSalary.value - totalAdvance.value + totalBonus.value;
        print("📊 Bu Ayın Net Maaşı: ₺${netSalary.value}");
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
