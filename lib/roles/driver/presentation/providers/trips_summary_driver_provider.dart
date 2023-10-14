import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/driver/infraestructure/models/trips_summary_driver_response.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_info_provider.dart';

final tripsSummaryDriverProvider = FutureProvider((ref) async {
  final driverInfo = await ref.watch(driverInfoProvider.future);
  if (driverInfo != null) {
    final response = await dio.get('trips/driver-summary', queryParameters: {
      'id': driverInfo.id,
    });
    final TripsSummaryDriverResponse tripsSummary =
        TripsSummaryDriverResponse.fromJson(response.data);

    return tripsSummary;
  }
  return null;
});
