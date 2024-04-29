import 'package:flutter_test/flutter_test.dart';
import 'package:silverapp/roles/driver/helpers/alert_end_trip.dart';

void main() {
  group('Function isInDesiredTimeRangeDriver', () {
    Function function = isInDesiredTimeRangeDriver;

    List<Map<String, dynamic>> values = [
      {"value": DateTime(2024, 4, 29, 0, 0), "result": false},
      {"value": DateTime(2024, 4, 29, 1, 5), "result": false},
      {"value": DateTime(2024, 4, 29, 2, 10), "result": false},
      {"value": DateTime(2024, 4, 29, 3, 15), "result": false},
      {"value": DateTime(2024, 4, 29, 4, 20), "result": false},
      {"value": DateTime(2024, 4, 29, 5, 25), "result": false},
      {"value": DateTime(2024, 4, 29, 6, 30), "result": false},
      {"value": DateTime(2024, 4, 29, 7, 35), "result": true},
      {"value": DateTime(2024, 4, 29, 8, 40), "result": true},
      {"value": DateTime(2024, 4, 29, 9, 45), "result": true},
      {"value": DateTime(2024, 4, 29, 10, 0), "result": true},
      {"value": DateTime(2024, 4, 29, 11, 5), "result": false},
      {"value": DateTime(2024, 4, 29, 12, 10), "result": false},
      {"value": DateTime(2024, 4, 29, 13, 15), "result": false},
      {"value": DateTime(2024, 4, 29, 14, 20), "result": false},
      {"value": DateTime(2024, 4, 29, 15, 25), "result": false},
      {"value": DateTime(2024, 4, 29, 16, 30), "result": false},
      {"value": DateTime(2024, 4, 29, 17, 35), "result": true},
      {"value": DateTime(2024, 4, 29, 18, 40), "result": true},
      {"value": DateTime(2024, 4, 29, 19, 45), "result": true},
      {"value": DateTime(2024, 4, 29, 20, 0), "result": true},
      {"value": DateTime(2024, 4, 29, 21, 5), "result": false},
      {"value": DateTime(2024, 4, 29, 22, 10), "result": false},
      {"value": DateTime(2024, 4, 29, 23, 15), "result": false},
    ];

    for (var element in values) {
      test(
          'Function index: ${values.indexOf(element)}, value: ${element['value']}, result: ${element['result']}.',
          () {
        expect(function(element['value']), element['result']);
        expect(function(element['value']), isA<bool>());
      });
    }
  });
}
