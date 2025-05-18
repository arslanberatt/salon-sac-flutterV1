import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';
import '../../utils/services/graphql_service.dart';

class ServiceController extends GetxController {
  final services = <Map<String, dynamic>>[].obs;
  final loading = false.obs;

  final String getServicesQuery = """
    query {
      services {
        id
        title
        duration
        price
      }
    }
  """;

  Future<void> fetchServices() async {
    loading.value = true;
    final client = GraphQLService.client.value;

    final result = await client.query(QueryOptions(
      document: gql(getServicesQuery),
      fetchPolicy: FetchPolicy.noCache,
    ));

    loading.value = false;

    if (result.hasException) {
      CustomSnackBar.errorSnackBar(
        title: "Hata",
        message: "Hizmetler alınamadı",
      );
      services.clear();
      return;
    }

    services.value = List<Map<String, dynamic>>.from(result.data?['services']);
  }

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }
}
