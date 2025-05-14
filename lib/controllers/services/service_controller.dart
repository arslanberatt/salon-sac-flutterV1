import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../utils/services/graphql_service.dart';

class ServiceController extends GetxController {
  final services = <Map<String, dynamic>>[].obs;
  final loading = false.obs;

  final String servicesQuery = """
    query {
      services {
        id
        title
        duration
        price
      }
    }
  """;

  void fetchServices() async {
    loading.value = true;

    final client = GraphQLService.client.value;
    final result = await client.query(QueryOptions(
        document: gql(servicesQuery), fetchPolicy: FetchPolicy.noCache));

    loading.value = false;

    if (result.hasException) {
      print("❌ Hata: ${result.exception}");
      services.clear();
      return;
    }

    services.value = List<Map<String, dynamic>>.from(result.data!['services']);
  }

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }
}
