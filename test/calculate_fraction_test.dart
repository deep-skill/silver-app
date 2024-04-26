import 'package:flutter_test/flutter_test.dart';
import 'package:silverapp/roles/driver/helpers/alert_end_trip.dart';

void main() {
  group('Function calculateFraction', () {
    Function function = calculateFraction;

    List<Map<String, dynamic>> values = [
      {"value": 60, "result": 1.0},
      {"value": 90, "result": 1.5},
      {"value": 110, "result": 2.0},
      {"value": 240, "result": 4.0},
      {"value": 200, "result": 3.5},
      {"value": 350, "result": 6.0},
      {"value": 0, "result": 0.0},
      {"value": 15, "result": 0.0},
      {"value": 16, "result": 0.5},
      {"value": 25, "result": 0.5},
      {"value": 30, "result": 0.5},
      {"value": 44, "result": 0.5},
      {"value": 45, "result": 1.0},
      {"value": 75, "result": 1.0},
      {"value": 125, "result": 2.0},
      {"value": 180, "result": 4.0},
      {"value": 195, "result": 3.0},
      {"value": 255, "result": 4.0},
      {"value": 275, "result": 4.5},
      {"value": 320, "result": 5.5},
      {"value": 375, "result": 6.0},
      {"value": 390, "result": 6.5},
      {"value": 420, "result": 8.0},
      {"value": 480, "result": 8.0},
      {"value": 600, "result": 10.0},
      {"value": 720, "result": 12.0},
    ];

    for (var element in values) {
      test(
          'The function receives many test cases {"value": ${element['value']}, "result": ${element['result']}} with this format.',
          () {
        expect(function(element['value']), element['result']);
        expect(function(element['value']), isA<double>());
      });
    }
  });
}
