import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_list.dart';

import 'package:silverapp/roles/driver/infraestructure/models/driver_trip_list_response.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_info_provider.dart';

List<DriverTripList> _jsonToReserves(Map<String, dynamic> json) {
  final driverTripsListResponse = DriverTripsListResponse.fromJson(json);
  final List<DriverTripList> trips = driverTripsListResponse.rows.toList();
  return trips;
}

final driverTripsListProvider =
    StateNotifierProvider<DriverTripsNotifier, List<DriverTripList>>((ref) {
  Future<List<DriverTripList>> getTrips({int page = 0}) async {
    final driverInfo = await ref.watch(driverInfoProvider.future);
    Credentials? credentials = ref.watch(authProvider).credentials;
    final response = await dio(credentials!.accessToken)
        .get('trips/driver-trips/${driverInfo?.id}', queryParameters: {
      'page': page,
    });
    return _jsonToReserves(response.data);
  }

  final fetchMoreTrips = getTrips;
  return DriverTripsNotifier(fetchMoreTrips: fetchMoreTrips);
});

typedef TripsCallback = Future<List<DriverTripList>> Function({int page});

class DriverTripsNotifier extends StateNotifier<List<DriverTripList>> {
  int currentPage = 0;
  bool isLoading = false;
  TripsCallback fetchMoreTrips;

  DriverTripsNotifier({
    required this.fetchMoreTrips,
  }) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    final List<DriverTripList> trips = await fetchMoreTrips(page: currentPage);
    currentPage++;
    state = [...state, ...trips];
    await Future.delayed(const Duration(milliseconds: 400));
    isLoading = false;
  }

  Future<void> reloadData() async {
    if (isLoading) return;
    currentPage = 0;
    isLoading = true;
    final List<DriverTripList> trips = await fetchMoreTrips(page: currentPage);
    currentPage++;
    state = [];
    state = [...trips];
    await Future.delayed(const Duration(milliseconds: 400));
    isLoading = false;
  }
}
