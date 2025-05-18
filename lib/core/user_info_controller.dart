import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobil/core/core/user_session_controller.dart';
import '../../utils/services/graphql_service.dart';

class UserInfoController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var role = ''.obs;
  var createdAt = ''.obs;
  var loading = false.obs;
  var isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserInfo();
  }

  final String getMyInfoQuery = """
    query GetEmployee(\$id: ID!) {
      employee(id: \$id) {
        id
        name
        phone
        email
        role
        createdAt
      }
    }
  """;

  final String updateMyInfoMutation = """
    mutation UpdateMyInfo(\$name: String, \$phone: String, \$password: String) {
      updateMyInfo(name: \$name, phone: \$phone, password: \$password) {
        id
        name
        phone
        email
        role
        createdAt
      }
    }
  """;

  Future<void> fetchUserInfo() async {
    final session = Get.find<UserSessionController>();
    final userId = session.id.value;

    if (userId.isEmpty) return;

    loading.value = true;

    try {
      final client = GraphQLService.client.value;
      final result = await client.query(
        QueryOptions(
          document: gql(getMyInfoQuery),
          variables: {"id": userId},
          fetchPolicy: FetchPolicy.noCache,
        ),
      );

      if (result.hasException) {
        Get.snackbar("Hata", result.exception.toString());
        return;
      }

      final data = result.data?["employee"];
      if (data != null) {
        name.value = data["name"];
        phone.value = data["phone"];
        email.value = data["email"];
        role.value = data["role"];
        createdAt.value = data["createdAt"];
      }
    } catch (e) {
      Get.snackbar("Hata", "Bilgi alınamadı: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateMyInfo({
    String? newName,
    String? newPhone,
    String? newPassword,
  }) async {
    isUpdating.value = true;

    try {
      final client = GraphQLService.client.value;

      final result = await client.mutate(
        MutationOptions(
          document: gql(updateMyInfoMutation),
          variables: {
            "name": newName,
            "phone": newPhone,
            "password": newPassword,
          },
        ),
      );

      if (result.hasException) {
        Get.snackbar("Hata", result.exception!.graphqlErrors.first.message);
        return;
      }

      final updated = result.data?["updateMyInfo"];
      if (updated != null) {
        name.value = updated["name"];
        phone.value = updated["phone"];
        email.value = updated["email"];
        role.value = updated["role"];
        createdAt.value = updated["createdAt"];
        Get.snackbar("Başarılı", "Bilgiler güncellendi.");
      }
    } catch (e) {
      Get.snackbar("Hata", "Güncelleme başarısız: $e");
    } finally {
      isUpdating.value = false;
    }
  }
}
