import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:silverapp/google_maps/routes_data_entity.dart';

Future<GoogleRoutes> getGoogleRoute(
    double startAddressLat,
    double startAddressLon,
    double? endAddressLat,
    double? endAddressLon,
    String departureTime) async {
  try {
    final response = await Dio().post(
      "https://routes.googleapis.com/directions/v2:computeRoutes",
      queryParameters: {
        'key': '${dotenv.env['GOOGLE_ROUTES_API_KEY']}',
      },
      data: {
        "origin": {
          "location": {
            "latLng": {
              "latitude": startAddressLat,
              "longitude": startAddressLon
            }
          }
        },
        "destination": {
          "location": {
            "latLng": {"latitude": endAddressLat, "longitude": endAddressLon}
          }
        },
        "travelMode": "DRIVE",
        "routingPreference": "TRAFFIC_AWARE",
        "departureTime": departureTime,
        "computeAlternativeRoutes": false,
        "routeModifiers": {
          "avoidTolls": false,
          "avoidHighways": false,
          "avoidFerries": false
        },
        "languageCode": "es",
        "units": "METRIC"
      },
      options: Options(
        headers: {
          'X-Goog-FieldMask':
              'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
        },
      ),
    );
    final googleRoutes = GoogleRoutes.fromJson(response.data);
    return googleRoutes;
  } catch (e) {
    throw Exception(
      'Error al obtener la ruta desde Google Maps. ${e.toString()}',
    );
  }
}

double calculateDistance(int distanceMeters) {
  return distanceMeters / 1000;
}

double calculateTime(int durationSeconds) {
  return durationSeconds / 60;
}

bool isInDesiredTimeRange(String stringTime) {
  DateFormat format = DateFormat.Hm();
  DateTime dateTime = format.parse(stringTime);
  int hour = dateTime.hour;
  return (hour >= 7 && hour <= 10) || (hour >= 17 && hour <= 20);
}

int calculateBasePrice(
  int distanceMeters,
  int durationSeconds,
  String type,
  bool additional,
) {
  double distanceKilometers = calculateDistance(distanceMeters);
  double timeMinutes = calculateTime(durationSeconds);
  if (type != 'Auto') {
    double truckBasePrice = 5 + 3.32 * distanceKilometers + 0.14 * timeMinutes;
    if (additional) return (truckBasePrice * 1.1).round();
    return truckBasePrice.round();
  }
  double basePrice = 4 + 1.95 * distanceKilometers + 0.20 * timeMinutes;
  if (additional) return (basePrice * 1.1).round();
  return basePrice.round();
}
