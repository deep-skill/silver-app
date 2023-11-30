import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio2.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/search_driver.dart';
import 'package:silverapp/roles/admin/infraestructure/models/search_driver_response.dart';

final searchDriversProvider = StateProvider<String>((ref) {
  return '';
});

List<SearchDriver> _jsonToDriver(List json) {
  final driversResponse = SearchDriverResponse.fromJson(json);
  final List<SearchDriver> drivers = driversResponse.drivers.toList();
  return drivers;
}

final searchedDriversProvider =
    StateNotifierProvider<SearchedDriversNotifier, List<SearchDriver>>((ref) {
  Future<List<SearchDriver>> searchDriver(query) async {
    Credentials? credentials = ref.watch(authProvider).credentials;
    if (query.isEmpty) return [];
    final response = await dio2(credentials!.accessToken)
        .get('/drivers/drivers', queryParameters: {
      'query': query,
    });
    return _jsonToDriver(response.data);
  }

  return SearchedDriversNotifier(
    searchDrivers: searchDriver,
    ref: ref,
  );
});

typedef SearchedDriversCallback = Future<List<SearchDriver>> Function(
    String query);

class SearchedDriversNotifier extends StateNotifier<List<SearchDriver>> {
  SearchedDriversNotifier({
    required this.ref,
    required this.searchDrivers,
  }) : super([]);

  final SearchedDriversCallback searchDrivers;
  final Ref ref;

  Future<List<SearchDriver>> searchDriversByQuery(String query) async {
    final List<SearchDriver> drivers = await searchDrivers(query);
    ref.read(searchDriversProvider.notifier).update((state) => query);
    state = drivers;
    return drivers;
  }
}
