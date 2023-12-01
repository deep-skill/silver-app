import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_list.dart';
import 'package:silverapp/roles/driver/infraestructure/models/search_driver_trip_response.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_info_provider.dart';

final searchDriverTripsProvider = StateProvider<String>((ref) {
  return '';
});

List<DriverTripList> _jsonToTrip(List json) {
  final tripsResponse = SearchDriverTripResponse.fromJson(json);
  final List<DriverTripList> trips = tripsResponse.trips.toList();
  return trips;
}

final searchedDriverTripsProvider =
    StateNotifierProvider<SearchedTripsNotifier, List<DriverTripList>>((ref) {
  Future<List<DriverTripList>> searchTrip(query) async {
    if (query.isEmpty) return [];
    final driverInfo = await ref.watch(driverInfoProvider.future);
    Credentials? credentials = ref.watch(authProvider).credentials;
    final response = await dio(credentials!.accessToken)
        .get('/trips/driver-search/${driverInfo?.id}', queryParameters: {
      'query': query,
    });
    return _jsonToTrip(response.data);
  }

  return SearchedTripsNotifier(
    searchTrips: searchTrip,
    ref: ref,
  );
});

typedef SearchedTripsCallback = Future<List<DriverTripList>> Function(
    String query);

class SearchedTripsNotifier extends StateNotifier<List<DriverTripList>> {
  SearchedTripsNotifier({
    required this.ref,
    required this.searchTrips,
  }) : super([]);

  final SearchedTripsCallback searchTrips;
  final Ref ref;

  Future<List<DriverTripList>> searchTripsByQuery(String query) async {
    final List<DriverTripList> trips = await searchTrips(query);
    ref.read(searchDriverTripsProvider.notifier).update((state) => query);
    state = trips;
    return trips;
  }
}
