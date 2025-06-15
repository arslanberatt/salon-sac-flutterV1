import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  static final storage = FlutterSecureStorage();

  static final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: _buildInitialLink(),
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  static Link _buildInitialLink() {
    final httpLink = HttpLink(
        'https://salonsacserver-production-3b83.up.railway.app/graphql');

    final authLink = AuthLink(
      getToken: () async {
        final token = await storage.read(key: 'token');
        print("🔐 Token yükleniyor: $token");
        return token != null ? 'Bearer $token' : null;
      },
    );

    return authLink.concat(httpLink);
  }

  static Future<void> refreshClient() async {
    client.value = GraphQLClient(
      link: _buildInitialLink(),
      cache: GraphQLCache(store: HiveStore()),
    );
    print("✅ GraphQLClient yenilendi.");
  }
}
