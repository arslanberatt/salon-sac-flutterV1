import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  static final storage = FlutterSecureStorage();

  static Future<GraphQLClient> initClient() async {
    final token = await storage.read(key: "token");

    final authLink = AuthLink(
      getToken: () async => token != null ? 'Bearer $token' : null,
    );

    final httpLink = HttpLink(
        'https://salonsacserver-production-3b83.up.railway.app/graphql');

    final link = authLink.concat(httpLink);

    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    );
  }

  static final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: HttpLink(
          'https://salonsacserver-production-3b83.up.railway.app/graphql'),
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  static Future<void> refreshClient() async {
    client.value = await initClient();
  }
}
