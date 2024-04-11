import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_list.dart';
import 'package:silverapp/roles/admin/infraestructure/models/trips_list_response.dart';

List<TripList> _jsonToTrips(Map<String, dynamic> json) {
  final tripListResponse = TripsListResponse.fromJson(json);
  final List<TripList> trips = tripListResponse.rows.toList();
  return trips;
}

final tripsListProvider =
    StateNotifierProvider<TripsNotifier, List<TripList>>((ref) {
  Future<List<TripList>> getTrips({int page = 0}) async {
    Credentials? credentials = ref.watch(authProvider).credentials;
    final response = await dio(credentials!.accessToken)
        .get('trips/admin-history', queryParameters: {
      'page': page,
    });
    return _jsonToTrips(response.data);
  }

  final fetchMoreTrips = getTrips;
  return TripsNotifier(fetchMoreTrips: fetchMoreTrips);
});

typedef TripCallback = Future<List<TripList>> Function({int page});

class TripsNotifier extends StateNotifier<List<TripList>> {
  int currentPage = 0;
  bool isLoading = false;
  bool lastPage = false;
  TripCallback fetchMoreTrips;

  TripsNotifier({
    required this.fetchMoreTrips,
  }) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    if (lastPage) return;
    //print('Loading new pages');
    isLoading = true;
    final List<TripList> reserves = await fetchMoreTrips(page: currentPage);
     if(reserves.isEmpty) {
      lastPage = true;
    }
    currentPage++;
    state = [...state, ...reserves];
    await Future.delayed(const Duration(milliseconds: 400));
    isLoading = false;
  }

  Future<void> reloadData() async {
    lastPage = true;
    if (isLoading) return;
    //print('Loading new pages');
    currentPage = 0;
    isLoading = true;
    final List<TripList> trips = await fetchMoreTrips(page: currentPage);
    currentPage++;
    state = [];
    state = [...trips];
    await Future.delayed(const Duration(milliseconds: 400));
    isLoading = false;
  }
}
