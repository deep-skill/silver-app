/* import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_list.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_info_provider.dart';

final searchDriverTripsProvider = StateProvider<String>((ref) {
  return '';
});

List<DriverTripList> _jsonToReserve(List json) {
  final reservesResponse = SearchDriverTripsResponse.fromJson(json);
  final List<DriverTripList> reserves = reservesResponse.reserves.toList();
  return reserves;
}

final searchedDriverReservesProvider =
    StateNotifierProvider<SearchedReservesNotifier, List<DriverTripList>>(
        (ref) {
  Future<List<DriverTripList>> searchReserve(query) async {
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

typedef SearchedReservesCallback = Future<List<DriverTripList>> Function(
    String query);

class SearchedReservesNotifier extends StateNotifier<List<DriverTripList>> {
  SearchedReservesNotifier({
    required this.ref,
    required this.searchReserves,
  }) : super([]);

  final SearchedReservesCallback searchReserves;
  final Ref ref;

  Future<List<DriverTripList>> searchReservesByQuery(String query) async {
    final List<DriverTripList> reserves = await searchReserves(query);
    ref.read(searchDriverReservesProvider.notifier).update((state) => query);
    state = reserves;
    return reserves;
  }
}
 */