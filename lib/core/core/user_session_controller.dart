// ✅ UserSessionController - Oturum yönetimi (ID, ad, rol)
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mobil/utils/services/graphql_service.dart';

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
    String? userName, // <-- eklendi
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
    final session = Get.find<UserSessionController>();
    session.clear(); // Session sıfırla

    const storage = FlutterSecureStorage();
    await storage.delete(key: "token"); // Token’ı sil

    await GraphQLService.refreshClient(); // Token’sız client oluştur

    Get.offAllNamed("/login"); // Giriş ekranına yönlendir
  }
}
