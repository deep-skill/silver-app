import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_end_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tripAdminStatusProvider =
    StateNotifierProvider<TripAdminStatusNotifier, Map<String, AdminTripEnd>>(
        (ref) {
  Future<AdminTripEnd> getTripAdminStatus(id) async {
    final response = await dio.get('trips/admin-trip/$id');
    return AdminTripEnd.fromJson(response.data);
  }

  final fetchTripAdminStatus = getTripAdminStatus;
  return TripAdminStatusNotifier(getTripAdminStatus: fetchTripAdminStatus);
});

typedef GetTripStateCallback = Future<AdminTripEnd> Function(
    String tripStatusId);

class TripAdminStatusNotifier extends StateNotifier<Map<String, AdminTripEnd>> {
  TripAdminStatusNotifier({
    required this.getTripAdminStatus,
  }) : super({});
  GetTripStateCallback getTripAdminStatus;

  Future<void> loadTripState(String tripStatusId) async {
    if (state[tripStatusId] != null) return;
    final tripStatus = await getTripAdminStatus(tripStatusId);
    state = {...state, tripStatusId: tripStatus};
  }
    Future<void> updateTripStatus(String tripStatusId) async {
    final tripStatus = await getTripAdminStatus(tripStatusId);
    state = {...state, tripStatus.id.toString(): tripStatus};
  }
}
