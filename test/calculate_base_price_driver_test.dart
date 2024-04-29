import 'package:flutter_test/flutter_test.dart';
import 'package:silverapp/roles/driver/helpers/alert_end_trip.dart';

void main() {
  group('Function calculateBasePriceDriver', () {
    Function function = calculateBasePriceDriver;

    List<Map<String, dynamic>> values = [
      //case minimum price
      {
        "distanceMeters": 1000,
        "durationSeconds": 3600,
        "type": "CAR",
        "additional": false,
        "result": 20.0
      },
      {
        "distanceMeters": 1000,
        "durationSeconds": 3600,
        "type": "CAR",
        "additional": true,
        "result": 22.0
      },
      {
        "distanceMeters": 4000,
        "durationSeconds": 3600,
        "type": "CAR",
        "additional": false,
        "result": 20.0
      },
      {
        "distanceMeters": 4000,
        "durationSeconds": 3600,
        "type": "CAR",
        "additional": true,
        "result": 22.0
      },
      {
        "distanceMeters": 6000,
        "durationSeconds": 3600,
        "type": "CAR",
        "additional": false,
        "result": 24.0
      },
      {
        "distanceMeters": 6000,
        "durationSeconds": 3600,
        "type": "CAR",
        "additional": true,
        "result": 27.0
      },
      {
        "distanceMeters": 1000,
        "durationSeconds": 3600,
        "type": "TRUCK",
        "additional": false,
        "result": 25.0
      },
      {
        "distanceMeters": 1000,
        "durationSeconds": 3600,
        "type": "TRUCK",
        "additional": true,
        "result": 28.0
      },
      {
        "distanceMeters": 4000,
        "durationSeconds": 3600,
        "type": "TRUCK",
        "additional": false,
        "result": 30.0
      },
      {
        "distanceMeters": 4000,
        "durationSeconds": 3600,
        "type": "TRUCK",
        "additional": true,
        "result": 33.0
      },
      {
        "distanceMeters": 6000,
        "durationSeconds": 3600,
        "type": "TRUCK",
        "additional": false,
        "result": 37.0
      },
      {
        "distanceMeters": 6000,
        "durationSeconds": 3600,
        "type": "TRUCK",
        "additional": true,
        "result": 41.0
      },
      {
        "distanceMeters": 6000,
        "durationSeconds": 3600,
        "type": "VAN",
        "additional": false,
        "result": 90.0
      },
      {
        "distanceMeters": 6000,
        "durationSeconds": 3600,
        "type": "VAN",
        "additional": true,
        "result": 99.0
      },
      {
        "distanceMeters": 24000,
        "durationSeconds": 3600,
        "type": "VAN",
        "additional": false,
        "result": 97.0
      },
      {
        "distanceMeters": 24000,
        "durationSeconds": 3600,
        "type": "VAN",
        "additional": true,
        "result": 106.0
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
