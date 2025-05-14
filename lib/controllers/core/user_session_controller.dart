import 'package:get/get.dart';

class UserSessionController extends GetxController {
  final id = ''.obs;
  final name = ''.obs;
  final role = ''.obs;

  bool get isLoggedIn => id.isNotEmpty;
  bool get isPatron => role.value == "patron";
  bool get isEmployee => role.value == "calisan";
  bool get isGuest => role.value == "misafir";

  void setUser({
    required String userId,
    required String userName,
    required String userRole,
  }) {
    id.value = userId;
    name.value = userName;
    role.value = userRole;

    print("🧠 Kullanıcı oturumu ayarlandı:");
    print("  ID: $userId");
    print("  Ad: $userName");
    print("  Rol: $userRole");
  }

  void clear() {
    id.value = '';
    name.value = '';
    role.value = '';
    print("🔒 Oturum temizlendi.");
  }

  void printSessionInfo() {
    print("🔍 Oturum Bilgisi:");
    print("  ID: ${id.value}");
    print("  Ad: ${name.value}");
    print("  Rol: ${role.value}");
    print("  Patron mu? $isPatron");
    print("  Çalışan mı? $isEmployee");
    print("  Misafir mi? $isGuest");
  }
}
