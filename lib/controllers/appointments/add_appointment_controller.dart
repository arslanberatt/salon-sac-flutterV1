// add_appointment_controller.dart
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../utils/services/graphql_service.dart';

class AddAppointmentController extends GetxController {
  final customers = <Map<String, dynamic>>[].obs;
  final employees = <Map<String, dynamic>>[].obs;
  final services = <Map<String, dynamic>>[].obs;

  final selectedCustomerId = ''.obs;
  final selectedEmployeeId = ''.obs;
  final selectedServiceIds = <String>[].obs;
  final selectedDateTime = Rxn<DateTime>();
  final notes = ''.obs;
  final loading = false.obs;

  final String customersQuery = """
    query {
      customers {
        id
        name
      }
    }
  """;

  final String employeesQuery = """
    query {
      employees {
        id
        name
      }
    }
  """;

  final String servicesQuery = """
    query {
      services {
        id
        title
        duration
        price
      }
    }
  """;

  final String addAppointmentMutation = """
    mutation AddAppointment(
      \$customerId: ID!
      \$employeeId: ID!
      \$serviceIds: [ID!]!
      \$startTime: String!
      \$totalPrice: Float!
      \$notes: String
    ) {
      addAppointment(
        customerId: \$customerId
        employeeId: \$employeeId
        serviceIds: \$serviceIds
        startTime: \$startTime
        totalPrice: \$totalPrice
        notes: \$notes
      ) {
        id
      }
    }
  """;

  void fetchAllData() async {
    loading.value = true;
    final client = GraphQLService.client.value;

    try {
      final c = await client.query(QueryOptions(
          document: gql(customersQuery), fetchPolicy: FetchPolicy.noCache));
      final e = await client.query(QueryOptions(
          document: gql(employeesQuery), fetchPolicy: FetchPolicy.noCache));
      final s = await client.query(QueryOptions(
          document: gql(servicesQuery), fetchPolicy: FetchPolicy.noCache));

      customers.value = List<Map<String, dynamic>>.from(c.data!['customers']);
      employees.value = List<Map<String, dynamic>>.from(e.data!['employees']);
      services.value = List<Map<String, dynamic>>.from(s.data!['services']);
    } catch (e) {
      print("❌ Veri çekme hatası: $e");
    } finally {
      loading.value = false;
    }
  }

  double get totalPrice {
    return services
        .where((s) => selectedServiceIds.contains(s['id']))
        .fold(0.0, (sum, item) => sum + (item['price'] as num).toDouble());
  }

  int get totalDuration {
    return services
        .where((s) => selectedServiceIds.contains(s['id']))
        .fold(0, (sum, item) => sum + (item['duration'] as int));
  }

  Future<bool> submitAppointment() async {
    final client = GraphQLService.client.value;
    loading.value = true;

    try {
      final result = await client.mutate(MutationOptions(
        document: gql(addAppointmentMutation),
        variables: {
          'customerId': selectedCustomerId.value,
          'employeeId': selectedEmployeeId.value,
          'serviceIds': selectedServiceIds,
          'startTime': selectedDateTime.value!.toIso8601String(),
          'totalPrice': totalPrice,
          'notes': notes.value.isEmpty ? null : notes.value,
        },
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        print("❌ Randevu oluşturma hatası: ${result.exception}");
        return false;
      }

      return true;
    } catch (e) {
      print("❌ Submit error: $e");
      return false;
    } finally {
      loading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }
}
