import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../utils/services/graphql_service.dart';

class TransactionController extends GetxController {
  final transactions = <Map<String, dynamic>>[].obs;
  final loading = false.obs;
  final visibleCount = 5.obs;
  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  final String fetchQuery = """
  query {
    transactions {
      id
      type
      amount
      description
      date
      canceled
      createdBy {
        id
        name
      }
    }
  }
""";

  final String cancelMutation = """
    mutation CancelTransaction(\$id: ID!) {
      cancelTransaction(id: \$id) {
        id
        canceled
      }
    }
  """;

  Future<void> fetchTransactions() async {
    loading.value = true;
    final client = GraphQLService.client.value;

    try {
      final result = await client.query(QueryOptions(
        document: gql(fetchQuery),
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        print("❌ GraphQL Exception: ${result.exception.toString()}");
        loading.value = false;
        return;
      }

      final rawList = result.data?['transactions'] ?? [];
      print("📦 Ham veri geldi: ${rawList.length} kayıt");

      final mappedList = List<Map<String, dynamic>>.from(rawList)
          .map((tx) {
            final createdBy = tx["createdBy"];
            final map = {
              "id": tx["id"],
              "type": tx["type"],
              "amount": tx["amount"],
              "description": tx["description"],
              "date": tx["date"],
              "canceled": tx["canceled"],
              "createdBy": {
                "id": createdBy?["id"],
                "name": createdBy?["name"] ?? "Bilinmiyor",
              },
              "createdAt": tx["date"],
            };
            return map;
          })
          .toList()
          .reversed
          .toList();
      ;

      transactions.value = mappedList;
      print("🎯 Toplam maplenen veri: ${transactions.length}");
    } catch (e) {
      print("❌ Hata: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> addTransaction({
    required String type,
    required double amount,
    required String description,
  }) async {
    final client = GraphQLService.client.value;

    final String mutation = """
    mutation AddTransaction(\$type: String!, \$amount: Float!, \$description: String!) {
      addTransaction(type: \$type, amount: \$amount, description: \$description) {
        id
        type
        amount
      }
    }
  """;

    try {
      final result = await client.mutate(MutationOptions(
        document: gql(mutation),
        variables: {
          "type": type,
          "amount": amount,
          "description": description,
        },
      ));

      if (result.hasException) {
        print("❌ Ekleme hatası: ${result.exception}");
      } else {
        await fetchTransactions();
      }
    } catch (e) {
      print("❌ Beklenmeyen hata: $e");
    }
  }

  Future<void> cancelTransaction(String id) async {
    final client = GraphQLService.client.value;

    try {
      await client.mutate(MutationOptions(
        document: gql(cancelMutation),
        variables: {"id": id},
      ));
      await fetchTransactions();
    } catch (e) {
      print("❌ İptal hatası: $e");
    }
  }

  double get totalIncome => transactions
      .where((e) => e['type'] == 'gelir' && !e['canceled'])
      .fold(0.0, (sum, e) => sum + (e['amount'] ?? 0.0));

  double get totalExpense => transactions
      .where((e) => e['type'] != 'gelir' && !e['canceled'])
      .fold(0.0, (sum, e) => sum + (e['amount'] ?? 0.0));
}
