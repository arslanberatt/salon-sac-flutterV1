// ✅ AuthController - Giriş işlemi ve session kaydı
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
        final graphqlErrors = result.exception!.graphqlErrors;
        final linkException = result.exception!.linkException;

        if (graphqlErrors.isNotEmpty) {
          Get.snackbar("Giriş Başarısız", graphqlErrors.first.message);
        } else if (linkException != null) {
          Get.snackbar("Ağ Hatası", linkException.toString());
        } else {
          Get.snackbar("Hata", "Bilinmeyen bir hata oluştu.");
        }

        print("⚠️ GraphQL Exception: ${result.exception.toString()}");
        return;
      }

      final token = result.data!["loginEmployee"]["token"];
      final employee = result.data!["loginEmployee"]["employee"];

      await storage.write(key: "token", value: token);
      await GraphQLService.refreshClient();

      final session = Get.find<UserSessionController>();

      session.name.value = employee["name"];
      print(session.name.value);

      session.setUser(
        userId: employee["id"],
        userRole: employee["role"],
      );

      if (session.isPatron || session.isEmployee) {
        Get.offAllNamed('/main');
      } else {
        Get.snackbar("Beklemede", "Hesabınız henüz onaylanmamış.");
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Get.snackbar("Hata", "Bir şeyler ters gitti. $e");
    } finally {
      loading.value = false;
    }
  }
}
