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

    final httpLink =
        HttpLink('http://10.0.2.2:8000/graphql'); // veya senin endpoint’in

    final link = authLink.concat(httpLink);

    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    );
  }

  static final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: HttpLink(
          'http://10.0.2.2:8000/graphql'), // geçici, yukarıda init'te dinamik olacak
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  static Future<void> refreshClient() async {
    client.value = await initClient();
  }
}
