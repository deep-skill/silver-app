import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:silverapp/google_maps/routes_data_entity.dart';

Future<GoogleRoutes> getGoogleRoute(
    double startAddressLat,
    double startAddressLon,
    double? endAddressLat,
    double? endAddressLon) async {
  print(endAddressLat);
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
        "departureTime": "2024-10-15T15:01:23.045123456Z",
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
