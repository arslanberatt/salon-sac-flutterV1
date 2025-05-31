import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';
import '../../utils/services/graphql_service.dart';
import '../core/user_session_controller.dart';

class AuthController extends GetxController {
  final storage = const FlutterSecureStorage();

  // Giriş için
  var email = ''.obs;
  var password = ''.obs;

  // Kayıt için
  var firstName = ''.obs;
  var lastName = ''.obs;
  var phone = ''.obs;
  var confirmPassword = ''.obs;

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

  final String registerMutation = """
    mutation RegisterEmployee(
      \$name: String!
      \$phone: String!
      \$email: String!
      \$password: String!
      \$role: String!
    ) {
      registerEmployee(
        name: \$name
        phone: \$phone
        email: \$email
        password: \$password
        role: \$role
      ) {
        id
        name
        email
        role
      }
    }
  """;

  /// 🔐 Giriş İşlemi
  Future<void> login() async {
    if (email.isEmpty || password.isEmpty) {
      CustomSnackBar.errorSnackBar(
        title: "Eksik Bilgi",
        message: "Email ve şifre boş olamaz.",
      );
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
        final error = result.exception!.graphqlErrors.firstOrNull?.message ??
            "Giriş sırasında hata oluştu.";
        CustomSnackBar.errorSnackBar(title: "Giriş Başarısız", message: error);
        return;
      }

      final token = result.data!["loginEmployee"]["token"];
      final employee = result.data!["loginEmployee"]["employee"];

      if (employee["role"] == "misafir") {
        CustomSnackBar.errorSnackBar(
          title: "Yetkisiz Giriş",
          message: "Hesabınız henüz onaylanmadı. Lütfen yöneticinize başvurun.",
        );
        return;
      }

      // Token kaydet
      await storage.write(key: "token", value: token);
      await GraphQLService.refreshClient();

      // Session'a kullanıcıyı ata
      final session = Get.find<UserSessionController>();
      session.setUser(
        userId: employee["id"],
        userRole: employee["role"],
        userName: employee["name"],
      );

      // Rol bazlı yönlendirme
      Get.offAllNamed('/main');
    } catch (e) {
      CustomSnackBar.errorSnackBar(
        title: "Hata",
        message: "Bir şeyler ters gitti. Tekrar deneyin.",
      );
    } finally {
      loading.value = false;
    }
  }

  /// 📝 Kayıt İşlemi
  Future<void> register() async {
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      CustomSnackBar.errorSnackBar(
        title: "Eksik Bilgi",
        message: "Tüm alanları doldurun.",
      );
      return;
    }

    if (password.value != confirmPassword.value) {
      CustomSnackBar.errorSnackBar(
        title: "Parola Hatası",
        message: "Parolalar uyuşmuyor.",
      );
      return;
    }

    loading.value = true;

    try {
      final client = GraphQLService.client.value;
      final result = await client.mutate(MutationOptions(
        document: gql(registerMutation),
        variables: {
          "name": "${firstName.value} ${lastName.value}",
          "phone": phone.value,
          "email": email.value,
          "password": password.value,
          "role": "misafir", // Yeni kayıtlar misafir olarak gelir
        },
        fetchPolicy: FetchPolicy.noCache,
        onCompleted: (data) => Get.back(result: true),
      ));

      if (result.hasException) {
        final error = result.exception!.graphqlErrors.firstOrNull?.message ??
            "Kayıt sırasında hata oluştu.";
        CustomSnackBar.errorSnackBar(title: "Kayıt Başarısız", message: error);
        return;
      }

      CustomSnackBar.successSnackBar(
        title: "Kayıt Başarılı",
        message: "Hesabınız oluşturuldu. Giriş yapabilirsiniz.",
      );
    } catch (e) {
      CustomSnackBar.errorSnackBar(
        title: "Hata",
        message: "Bir şeyler ters gitti. Tekrar deneyin.",
      );
    } finally {
      loading.value = false;
    }
  }
}
