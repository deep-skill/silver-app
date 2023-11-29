import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_list.dart';
import 'package:silverapp/roles/admin/infraestructure/models/search_trip_response.dart';

final searchTripsProvider = StateProvider<String>((ref) {
  return '';
});

List<TripList> _jsonToTrip(List json) {
  final tripsResponse = SearchTripResponse.fromJson(json);
  final List<TripList> trips = tripsResponse.trips.toList();
  return trips;
}

final searchedTripsProvider =
    StateNotifierProvider<SearchedTripsNotifier, List<TripList>>((ref) {
  Future<List<TripList>> searchTrip(query) async {
    if (query.isEmpty) return [];
    final response = await dio.get('/trips/trip-search/', queryParameters: {
      'query': query,
    });
    return _jsonToTrip(response.data);
  }

  return SearchedTripsNotifier(
    searchTrips: searchTrip,
    ref: ref,
  );
});

typedef SearchedTripsCallback = Future<List<TripList>> Function(String query);

class SearchedTripsNotifier extends StateNotifier<List<TripList>> {
  SearchedTripsNotifier({
    required this.ref,
    required this.searchTrips,
  }) : super([]);

  final SearchedTripsCallback searchTrips;
  final Ref ref;

  Future<List<TripList>> searchTripsByQuery(String query) async {
    final List<TripList> trips = await searchTrips(query);
    ref.read(searchTripsProvider.notifier).update((state) => query);
    state = trips;
    return trips;
  }
}
