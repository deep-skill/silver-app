import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';
import 'package:silverapp/roles/admin/infraestructure/models/search_reserve_response.dart';

final searchReservesProvider = StateProvider<String>((ref) {
  return '';
});

List<ReserveList> _jsonToReserve(List json) {
  final reservesResponse = SearchReserveResponse.fromJson(json);
  final List<ReserveList> reserves =
      reservesResponse.reserves.toList();
  return reserves;
}

final searchedReservesProvider =
    StateNotifierProvider<SearchedReservesNotifier, List<ReserveList>>(
        (ref) {
  Future<List<ReserveList>> searchReserve(query) async {
    if (query.isEmpty) return [];
    final response = await dio.get('/reserves/search/', queryParameters: {
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
    ref.read(searchReservesProvider.notifier).update((state) => query);
    state = reserves;
    return reserves;
  }
}