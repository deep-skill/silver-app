import 'package:flutter_test/flutter_test.dart';
import 'package:silverapp/roles/driver/helpers/alert_end_trip.dart';

void main() {
  group('Function calculateDistance', () {
    Function function = calculateDistance;

    List<Map<String, dynamic>> values = [
      {"value": 10, "result": 0.01},
      {"value": 20, "result": 0.02},
      {"value": 30, "result": 0.03},
      {"value": 40, "result": 0.04},
      {"value": 50, "result": 0.05},
      {"value": 60, "result": 0.06},
      {"value": 70, "result": 0.07},
      {"value": 80, "result": 0.08},
      {"value": 90, "result": 0.09},
      {"value": 100, "result": 0.1},
      {"value": 1100, "result": 1.1},
      {"value": 1200, "result": 1.2},
      {"value": 1300, "result": 1.3},
      {"value": 1400, "result": 1.4},
      {"value": 1500, "result": 1.5},
      {"value": 1600, "result": 1.6},
      {"value": 1700, "result": 1.7},
      {"value": 1800, "result": 1.8},
      {"value": 1900, "result": 1.9},
      {"value": 2000, "result": 2.0},
    ];

    for (var element in values) {
      test(
          'Function index: ${values.indexOf(element)}, value: ${element['value']}, "result": ${element['result']}, with this format.',
          () {
        expect(function(element['value']), element['result']);
        expect(function(element['value']), isA<double>());
      });
    }
  });
}
