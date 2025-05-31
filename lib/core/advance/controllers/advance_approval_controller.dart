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

      final rawData =
          List<Map<String, dynamic>>.from(result.data!['advanceRequests']);

      // ✅ createdAt'e göre sıralama (en yeni en üstte)
      rawData.sort((a, b) {
        final aDate = _parseDate(a['createdAt']);
        final bDate = _parseDate(b['createdAt']);
        return bDate.compareTo(aDate);
      });

      advanceList.value = rawData;
      advanceWaitList.value =
          rawData.where((e) => e['status'] == 'beklemede').toList();
    } catch (e) {
      print("❌ Hata: $e");
    } finally {
      loading.value = false;
    }
  }

  DateTime _parseDate(dynamic rawDate) {
    if (rawDate == null) return DateTime(2000);

    if (rawDate is int) {
      return DateTime.fromMillisecondsSinceEpoch(rawDate);
    }

    if (rawDate is String && RegExp(r'^\d+$').hasMatch(rawDate)) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(rawDate));
    }

    return DateTime.tryParse(rawDate.toString()) ?? DateTime(2000);
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
