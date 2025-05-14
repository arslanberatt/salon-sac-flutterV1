import 'package:mobil/screens/appointments/add_appointment_screen.dart';
import 'package:mobil/screens/boss/add_service_screen.dart';
import 'package:mobil/screens/boss/advance_approval_screen.dart';
import 'package:mobil/screens/employee/advance_request_screen.dart';
import 'package:mobil/screens/boss/employees_screen.dart';
import 'package:mobil/screens/common/profile_screen.dart';
import 'package:mobil/screens/employee/salary_record_screen.dart';
import 'package:mobil/screens/boss/service_list_screen.dart';
import 'package:mobil/screens/common/settings_screen.dart';
import 'package:mobil/screens/boss/transaction_screen.dart';
import 'package:get/get.dart';
import '../screens/common/splash_screen.dart';
import '../screens/common/login_screen.dart';
import '../layouts/main_layout.dart';
import '../screens/customers/add_customer_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String main = '/main';
  static const String addCustomer = '/add-customer';
  static const String addService = '/add-service';
  static const String listService = '/services';
  static const String addAppointment = '/add-appointment';
  static const String employees = '/employees';
  static const String advanceRequests = '/advance-requests';
  static const String advanceApproval = '/advance-approval';
  static const String transaction = '/transaction';
  static const String salaryRecord = '/salary_record';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static final List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: main, page: () => const MainLayout()),
    GetPage(name: addCustomer, page: () => const AddCustomerScreen()),
    GetPage(name: addService, page: () => const AddServiceScreen()),
    GetPage(name: listService, page: () => const ServiceListScreen()),
    GetPage(name: addAppointment, page: () => const AddAppointmentScreen()),
    GetPage(name: employees, page: () => const EmployeesScreen()),
    GetPage(name: advanceRequests, page: () => const RequestAdvanceScreen()),
    GetPage(name: advanceApproval, page: () => const AdvanceApprovalScreen()),
    GetPage(name: transaction, page: () => const TransactionScreen()),
    GetPage(name: salaryRecord, page: () => const SalaryRecordScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
  ];
}
