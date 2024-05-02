import 'package:flutter_test/flutter_test.dart';
import 'package:silverapp/google_maps/google_post_routes.dart';

void main() {
  group('Function isInDesiredTimeRangeDriver', () {
    Function function = calculateInRushHourAdmin;

    List<Map<String, dynamic>> values = [
      {"value": '00:00', "result": false},
      {"value": '01:00', "result": false},
      {"value": '02:00', "result": false},
      {"value": '03:00', "result": false},
      {"value": '04:00', "result": false},
      {"value": '05:00', "result": false},
      {"value": '06:00', "result": false},
      {"value": '07:00', "result": true},
      {"value": '08:00', "result": true},
      {"value": '09:00', "result": true},
      {"value": '10:00', "result": true},
      {"value": '10:01', "result": false},
      {"value": '11:00', "result": false},
      {"value": '12:00', "result": false},
      {"value": '13:00', "result": false},
      {"value": '14:00', "result": false},
      {"value": '15:00', "result": false},
      {"value": '16:00', "result": false},
      {"value": '17:00', "result": true},
      {"value": '18:00', "result": true},
      {"value": '19:00', "result": true},
      {"value": '20:00', "result": true},
      {"value": '20:01', "result": false},
      {"value": '21:00', "result": false},
      {"value": '22:00', "result": false},
      {"value": '23:00', "result": false},
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
