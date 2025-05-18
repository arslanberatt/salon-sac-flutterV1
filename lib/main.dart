import 'package:mobil/core/core/user_session_controller.dart';
import 'package:mobil/core/transactions/transaction_controller.dart';
import 'package:mobil/utils/services/graphql_service.dart';
import 'package:mobil/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'routes/app_pages.dart';
import 'routes/app_pages.dart' as routes;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  await GraphQLService.refreshClient();
  Get.put(UserSessionController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TransactionController());
    return GetMaterialApp(
      theme: MyThemes.lightTheme,
      title: 'Salon Saç',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}
