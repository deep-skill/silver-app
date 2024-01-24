import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/user/models/trip_summary_response.dart';

final dio = Dio(BaseOptions(
  baseUrl: '${dotenv.env['HTTP_REQUEST']}',
));

final tripsSummaryProvider = FutureProvider<TripsSummaryResponse>((ref) async {
  final response = await dio.get(
    'trips/admin-summary',
  );

  final TripsSummaryResponse tripsSummary =
      TripsSummaryResponse.fromJson(response.data);

  return tripsSummary;
});
