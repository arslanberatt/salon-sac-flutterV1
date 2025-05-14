import 'package:get/get.dart';

class SettingsController extends GetxController {
  final name = "John Doe".obs;
  final email = "john.doe@mail.com".obs;

  final emailNotifications = true.obs;
  final pushNotifications = false.obs;

  final selectedLanguage = "English".obs;
  final selectedLocation = "Los Angeles, CA".obs;

  void toggleEmailNotifications(bool value) {
    emailNotifications.value = value;
    // API çağrısı vs yapılabilir
  }

  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
  }

  void logout() {
    // Çıkış işlemleri
    Get.offAllNamed("/login");
  }
}
