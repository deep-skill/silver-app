import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/admin/infraestructure/models/trip_summary_response.dart';


final tripsSummaryProvider = FutureProvider<TripsSummaryResponse>((ref) async {
  final response = await dio.get(
    'trips/admin-summary',
  );

  final TripsSummaryResponse tripsSummary =
      TripsSummaryResponse.fromJson(response.data);

  return tripsSummary;
});
