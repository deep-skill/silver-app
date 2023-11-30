import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio2.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/admin/infraestructure/models/trip_summary_response.dart';

final tripsSummaryProvider = FutureProvider<TripsSummaryResponse>((ref) async {
  Credentials? credentials = ref.watch(authProvider).credentials;
  final response = await dio2(credentials!.accessToken).get(
    'trips/admin-summary',
  );

  final TripsSummaryResponse tripsSummary =
      TripsSummaryResponse.fromJson(response.data);

  return tripsSummary;
});
