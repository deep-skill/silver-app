import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_list.dart';
import 'package:silverapp/roles/driver/infraestructure/models/search_driver_reserve_response.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_info_provider.dart';

final searchDriverReservesProvider = StateProvider<String>((ref) {
  return '';
});

List<DriverReserveList> _jsonToReserve(List json) {
  final reservesResponse = SearchDriverReserveResponse.fromJson(json);
  final List<DriverReserveList> reserves = reservesResponse.reserves.toList();
  return reserves;
}

final searchedDriverReservesProvider =
    StateNotifierProvider<SearchedReservesNotifier, List<DriverReserveList>>(
        (ref) {
  Future<List<DriverReserveList>> searchReserve(query) async {
    if (query.isEmpty) return [];
    final driverInfo = await ref.watch(driverInfoProvider.future);
    final response = await dio
        .get('/reserves/driver-search/${driverInfo?.id}', queryParameters: {
      'query': query,
    });
    return _jsonToReserve(response.data);
  }

  return SearchedReservesNotifier(
    searchReserves: searchReserve,
    ref: ref,
  );
});

typedef SearchedReservesCallback = Future<List<DriverReserveList>> Function(
    String query);

class SearchedReservesNotifier extends StateNotifier<List<DriverReserveList>> {
  SearchedReservesNotifier({
    required this.ref,
    required this.searchReserves,
  }) : super([]);

  final SearchedReservesCallback searchReserves;
  final Ref ref;

  Future<List<DriverReserveList>> searchReservesByQuery(String query) async {
    final List<DriverReserveList> reserves = await searchReserves(query);
    ref.read(searchDriverReservesProvider.notifier).update((state) => query);
    state = reserves;
    return reserves;
  }
}
