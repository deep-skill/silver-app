import '../../../../config/dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';

final tripDriverStatusProvider = StateNotifierProvider<TripDriverStatusNotifier,
    Map<String, TripDriverStatus>>((ref) {
  Future<TripDriverStatus> getTripDriverStatus(id) async {
    final response = await dio.get('trips/driver-trip/$id');
    return TripDriverStatus.fromJson(response.data);
  }

  final fetchTripDriverStatus = getTripDriverStatus;
  return TripDriverStatusNotifier(getTripDriverStatus: fetchTripDriverStatus);
});

typedef GetTripStateCallback = Future<TripDriverStatus> Function(
    String tripStatusId);

class TripDriverStatusNotifier
    extends StateNotifier<Map<String, TripDriverStatus>> {
  TripDriverStatusNotifier({
    required this.getTripDriverStatus,
  }) : super({});
  GetTripStateCallback getTripDriverStatus;

  Future<void> loadTripState(String tripStatusId) async {
    if (state[tripStatusId] != null) return;
    final tripStatus = await getTripDriverStatus(tripStatusId);
    state = {...state, tripStatusId: tripStatus};
  }
}
