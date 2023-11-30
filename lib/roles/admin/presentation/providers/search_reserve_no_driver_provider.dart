import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio2.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';
import 'package:silverapp/roles/admin/infraestructure/models/search_reserve_response.dart';

final searchNoDriverReservesProvider = StateProvider<String>((ref) {
  return '';
});

List<ReserveList> _jsonToReserve(List json) {
  final reservesResponse = SearchReserveResponse.fromJson(json);
  final List<ReserveList> reserves = reservesResponse.reserves.toList();
  return reserves;
}

final searchedNoDriverReservesProvider =
    StateNotifierProvider<SearchedReservesNotifier, List<ReserveList>>((ref) {
  Future<List<ReserveList>> searchReserve(query) async {
    Credentials? credentials = ref.watch(authProvider).credentials;
    if (query.isEmpty) return [];
    final response = await dio2(credentials!.accessToken)
        .get('/reserves/admin-search-home/', queryParameters: {
      'query': query,
    });
    return _jsonToReserve(response.data);
  }

  return SearchedReservesNotifier(
    searchReserves: searchReserve,
    ref: ref,
  );
});

typedef SearchedReservesCallback = Future<List<ReserveList>> Function(
    String query);

class SearchedReservesNotifier extends StateNotifier<List<ReserveList>> {
  SearchedReservesNotifier({
    required this.ref,
    required this.searchReserves,
  }) : super([]);

  final SearchedReservesCallback searchReserves;
  final Ref ref;

  Future<List<ReserveList>> searchReservesByQuery(String query) async {
    final List<ReserveList> reserves = await searchReserves(query);
    ref.read(searchNoDriverReservesProvider.notifier).update((state) => query);
    state = reserves;
    return reserves;
  }
}
