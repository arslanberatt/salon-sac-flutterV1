import 'package:mobil/utils/services/graphql_service.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AdvanceApprovalController extends GetxController {
  final advanceList = <Map<String, dynamic>>[].obs;
  final advanceWaitList = <Map<String, dynamic>>[].obs;
  final loading = false.obs;

  final String fetchQuery = """
    query {
      advanceRequests {
        id
        amount
        reason
        status
        createdAt
        employee {
          id
          name
        }
      }
    }
  """;

  final String approveMutation = """
    mutation ApproveAdvanceRequest(\$id: ID!) {
      approveAdvanceRequest(id: \$id) {
        id
        status
      }
    }
  """;

  final String rejectMutation = """
    mutation RejectAdvanceRequest(\$id: ID!) {
      rejectAdvanceRequest(id: \$id) {
        id
        status
      }
    }
  """;

  Future<void> fetchAdvanceRequests() async {
    loading.value = true;
    final client = GraphQLService.client.value;

    try {
      final result = await client.query(QueryOptions(
        document: gql(fetchQuery),
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        print("❌ Avans talepleri alınamadı: ${result.exception}");
        return;
      }

      final allData =
          List<Map<String, dynamic>>.from(result.data!['advanceRequests']);
      advanceList.value = allData;

      // 🔎 Beklemede olanları ayıkla
      advanceWaitList.value =
          allData.where((e) => e['status'] == 'beklemede').toList();
    } catch (e) {
      print("❌ Hata: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateStatus(String id, bool approve) async {
    final client = GraphQLService.client.value;
    final mutation = approve ? approveMutation : rejectMutation;

    try {
      await client.mutate(MutationOptions(
        document: gql(mutation),
        variables: {"id": id},
      ));
      await fetchAdvanceRequests(); // yenile
    } catch (e) {
      print("❌ Güncelleme hatası: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAdvanceRequests();
  }
}
