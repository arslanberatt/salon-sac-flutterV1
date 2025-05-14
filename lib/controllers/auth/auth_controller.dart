import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../utils/services/graphql_service.dart';
import '../core/user_session_controller.dart';

class AuthController extends GetxController {
  final storage = const FlutterSecureStorage();

  var email = ''.obs;
  var password = ''.obs;
  var loading = false.obs;

  final String loginMutation = """
    mutation LoginEmployee(\$email: String!, \$password: String!) {
      loginEmployee(email: \$email, password: \$password) {
        token
        employee {
          id
          name
          role
        }
      }
    }
  """;

  void login() async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Hata", "Email ve şifre boş olamaz");
      return;
    }

    loading.value = true;
    print("🔐 Giriş işlemi başlatıldı...");

    try {
      final client = GraphQLService.client.value;
      final result = await client.mutate(MutationOptions(
        document: gql(loginMutation),
        variables: {
          "email": email.value,
          "password": password.value,
        },
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        print("❌ Giriş hatası: ${result.exception}");
        Get.snackbar(
            "Giriş Başarısız", result.exception!.graphqlErrors.first.message);
        return;
      }

      final token = result.data!["loginEmployee"]["token"];
      final employee = result.data!["loginEmployee"]["employee"];

      print("✅ Token alındı");
      print("👤 Kullanıcı: ${employee["name"]}, Rol: ${employee["role"]}");

      // Token'ı güvenli sakla
      await storage.write(key: "token", value: token);

      // Yeni token ile GraphQL client'ı yenile
      await GraphQLService.refreshClient();

      // Oturumu güncelle
      final session = Get.find<UserSessionController>();
      session.setUser(
        userId: employee["id"],
        userName: employee["name"],
        userRole: employee["role"],
      );

      print(
          "🧠 Session => ID: ${session.id.value}, Rol: ${session.role.value}");

      // Role göre yönlendirme
      if (session.isPatron || session.isEmployee) {
        Get.offAllNamed('/main');
      } else {
        Get.snackbar("Beklemede", "Hesabınız henüz onaylanmamış.");
        Get.offAllNamed('/login');
      }
    } catch (e, stacktrace) {
      print("❌ Login Exception: $e");
      print("📍 Stacktrace: $stacktrace");
      Get.snackbar("Hata", "Bir şeyler ters gitti. $e");
    } finally {
      loading.value = false;
    }
  }
}
