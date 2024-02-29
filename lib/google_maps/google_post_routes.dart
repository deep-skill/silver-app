import 'package:dio/dio.dart';

Future<dynamic> getGoogleRoute(String address) async {
  var googleRoute = await Dio().post(
    "https://routes.googleapis.com/directions/v2:computeRoutes",
    queryParameters: {
      'key': 'AIzaSyDeQuPr7mCN9vfbpwjvmomgiLbKULl8oMw',
    },
    data: {
      "origin": {
        "address": "1800 Amphitheatre Parkway, Mountain View, CA 94043"
      },
      "destination": {
        "address": "Sloat Blvd &, Upper Great Hwy, San Francisco, CA 94132"
      },
      "travelMode": "DRIVE"
    },
    options: Options(
      headers: {
        'X-Goog-FieldMask':
            'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
      },
    ),
  );
  return googleRoute;
}
