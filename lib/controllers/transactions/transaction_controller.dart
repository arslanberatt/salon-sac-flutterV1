import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../utils/services/graphql_service.dart';

class TransactionController extends GetxController {
  final transactions = <Map<String, dynamic>>[].obs;
  final loading = false.obs;

  final String fetchQuery = """
    query {
      transactions {
        id
        type
        amount
        description
        date
        canceled
        createdBy
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
        print("❌ Transaction sorgu hatası: ${result.exception}");
        return;
      }

      transactions.value =
          List<Map<String, dynamic>>.from(result.data!['transactions']);
    } catch (e) {
      print("❌ Hata: $e");
    } finally {
      loading.value = false;
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

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  final visibleCount = 5.obs;

  void loadMore() {
    visibleCount.value += 5;
  }
}
