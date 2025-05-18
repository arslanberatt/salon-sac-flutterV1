// ✅ UserSessionController - Oturum yönetimi (ID, ad, rol)
import 'package:get/get.dart';

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
}
