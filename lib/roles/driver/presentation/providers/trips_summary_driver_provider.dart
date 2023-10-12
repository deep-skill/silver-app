import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/driver/infraestructure/models/trips_summary_driver_response.dart';


final tripsSummaryDriverProvider = FutureProvider.family((ref, int id) async {
  final response = await dio.get(
    'trips/driver-summary', queryParameters: {
      'id': id,
    }
  );
  final TripsSummaryDriverResponse tripsSummary =
      TripsSummaryDriverResponse.fromJson(response.data);

  return tripsSummary;
});
