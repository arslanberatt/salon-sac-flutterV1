import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobil/routes/app_pages.dart';
import 'package:mobil/utils/services/graphql_service.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';

class UserSessionController extends GetxController {
  final id = ''.obs;
  var name = ''.obs;
  final role = ''.obs;

  bool get isLoggedIn => id.isNotEmpty;
  bool get isPatron => role.value == "patron";
  bool get isEmployee => role.value == "calisan";
  bool get isGuest => role.value == "misafir";

  void setUser({
    required String userId,
    required String userRole,
    String? userName,
  }) {
    id.value = userId;
    role.value = userRole;
    if (userName != null) {
      name.value = userName;
    }
  }

  void clear() {
    id.value = '';
    role.value = '';
  }

  Future<void> logoutUser() async {
    clear(); // Session sıfırla
    const storage = FlutterSecureStorage();
    await storage.delete(key: "token"); // Token’ı sil
    await GraphQLService.refreshClient(); // Yeni (anonim) client
    Get.offAllNamed(AppRoutes.login); // Login ekranına yönlendir
  }

  Future<void> autoLogoutIfGuest() async {
    final client = GraphQLService.client.value;

    const String query = """
        query GetMyRole(\$id: ID!) {
          employee(id: \$id) {
            id
            role
          }
        }
      """;

    final result = await client.query(
      QueryOptions(
        document: gql(query),
        variables: {"id": id.value},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (!result.hasException) {
      final currentRole = result.data?["employee"]?["role"];
      if (currentRole == "misafir") {
        CustomSnackBar.errorSnackBar(
            title: "Oturumunuz sonlandı", message: "Yetkiniz kaldırıldı!");
        await logoutUser();
      }
    } else {
      print("❌ Rol kontrolü başarısız: ${result.exception.toString()}");
    }
  }
}
