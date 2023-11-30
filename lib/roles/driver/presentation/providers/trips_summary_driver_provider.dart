import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio2.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/driver/infraestructure/models/trips_summary_driver_response.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_info_provider.dart';

final tripsSummaryDriverProvider = FutureProvider((ref) async {
  final driverInfo = await ref.watch(driverInfoProvider.future);
  Credentials? credentials = ref.watch(authProvider).credentials;
  try {
    if (driverInfo != null) {
      final response = await dio2(credentials!.accessToken)
          .get('trips/driver-summary', queryParameters: {
        'id': driverInfo.id,
      });
      if (response.data != null) {
        final TripsSummaryDriverResponse tripsSummary =
            TripsSummaryDriverResponse.fromJson(response.data);
        return tripsSummary;
      }
    }
  } catch (e) {
    print(e);
  }

  return null;
});
