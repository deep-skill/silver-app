import 'package:flutter_test/flutter_test.dart';
import 'package:silverapp/google_maps/google_post_routes.dart';

void main() {
  group('Function calculateBasePriceDriver', () {
    Function function = calculateBasePrice;

    List<Map<String, dynamic>> values = [
      {
        "distanceMeters": 1000,
        "durationSeconds": 3600,
        "type": "Car",
        "additional": false,
        "result": 20.0
      },
      {
        "distanceMeters": 1000,
        "durationSeconds": 3600,
        "type": "Car",
        "additional": true,
        "result": 22.0
      },
      {
        "distanceMeters": 4000,
        "durationSeconds": 3600,
        "type": "Car",
        "additional": false,
        "result": 20.0
      },
      {
        "distanceMeters": 4000,
        "durationSeconds": 3600,
        "type": "Car",
        "additional": true,
        "result": 22.0
      },
      {
        "distanceMeters": 6000,
        "durationSeconds": 3600,
        "type": "Car",
        "additional": false,
        "result": 24.0
      },
      {
        "distanceMeters": 6000,
        "durationSeconds": 3600,
        "type": "Car",
        "additional": true,
        "result": 27.0
      },
      {
        "distanceMeters": 1000,
        "durationSeconds": 3600,
        "type": "Camioneta",
        "additional": false,
        "result": 25.0
      },
      {
        "distanceMeters": 1000,
        "durationSeconds": 3600,
        "type": "Camioneta",
        "additional": true,
        "result": 28.0
      },
      {
        "distanceMeters": 4000,
        "durationSeconds": 3600,
        "type": "Camioneta",
        "additional": false,
        "result": 30.0
      },
      {
        "distanceMeters": 4000,
        "durationSeconds": 3600,
        "type": "Camioneta",
        "additional": true,
        "result": 33.0
      },
      {
        "distanceMeters": 6000,
        "durationSeconds": 3600,
        "type": "Camioneta",
        "additional": false,
        "result": 37.0
      },
      {
        "distanceMeters": 6000,
        "durationSeconds": 3600,
        "type": "Camioneta",
        "additional": true,
        "result": 41.0
      },
    ];

    for (var element in values) {
      test(
          'Function index: ${values.indexOf(element)}, typeCar: ${element['type']}, distance: ${element['distanceMeters'] / 1000}, duration: ${element['durationSeconds'] / 60}, additional: ${element['additional']} , "result": ${element['result']}, with this format.',
          () {
        expect(
            function(element['distanceMeters'], element['durationSeconds'],
                element['type'], element['additional']),
            element['result']);
      });
    }
  });
}
