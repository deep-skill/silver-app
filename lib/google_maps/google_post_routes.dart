import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:silverapp/env/env.dart';
import 'package:silverapp/google_maps/routes_data_entity.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';

Future<GoogleRoutes> getGoogleRoute(
    double startAddressLat,
    double startAddressLon,
    double? endAddressLat,
    double? endAddressLon,
    String departureTime) async {
  try {
    final response = await Dio().post(
      "https://routes.googleapis.com/directions/v2:computeRoutes",
      queryParameters: {'key': kIsWeb ? Env.webApi : Env.androidApi},
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
    return GoogleRoutes(routes: []);
  }
}

double calculateDistance(int distanceMeters) {
  return distanceMeters / 1000;
}

double calculateTime(int durationSeconds) {
  return durationSeconds / 60;
}

bool calculateInRushHourAdmin(String stringTime) {
  DateFormat format = DateFormat.Hm();
  DateTime dateTime = format.parse(stringTime);
  int hour = dateTime.hour;
  if (hour == 10 || hour == 20) {
    if (dateTime.minute == 0) return true;
  }
  return (hour >= 7 && hour <= 9) || (hour >= 17 && hour <= 19);
}

int calculateBasePrice(
  int distanceMeters,
  int durationSeconds,
  String type,
  bool additional,
) {
  double distanceKilometers = calculateDistance(distanceMeters);
  double timeMinutes = calculateTime(durationSeconds);

  if (type == 'Camioneta' || type == 'Van') {
    double truckBasePrice = 5 + 3.32 * distanceKilometers + 0.20 * timeMinutes;
    if (additional) {
      if (truckBasePrice < 27.0) return 28;
      return (truckBasePrice * 1.1).round();
    } else {
      if (truckBasePrice < 25.0) return 25;
      return truckBasePrice.round();
    }
  }
  double basePrice = 4 + 1.95 * distanceKilometers + 0.14 * timeMinutes;
  if (additional) {
    if (basePrice < 22) return 22;
    return (basePrice * 1.1).round();
  } else {
    if (basePrice < 20) return 20;
    return basePrice.round();
  }
}

String getDirectionsUrl(double originLat, double originLon,
    double? destinationLat, double? destinationLon, List<Stop> stops) {
  final origin = '$originLat,$originLon';
  final destination = '$destinationLat,$destinationLon';
  final waypointsString =
      stops.map((waypoint) => 'via:${waypoint.lat},${waypoint.lon}').join('|');
  final apiKey = kIsWeb ? Env.webApi : Env.androidApi;

  return 'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&waypoints=$waypointsString&key=$apiKey';
}

Future<ResponseRoute?> calculateRouteAndStops(String url) async {
  var response = await Dio().get(url);
  if (response.data['status'] == "ZERO_RESULTS") return null;

  ResponseRoute responseRoute = ResponseRoute(
    distance: response.data['routes'][0]['legs'][0]['distance']['value'],
    time: response.data['routes'][0]['legs'][0]['duration']['value'],
    encodedPolyline: response.data['routes'][0]['overview_polyline']['points'],
  );
  return responseRoute;
}
