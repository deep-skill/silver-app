import 'package:flutter_test/flutter_test.dart';
import 'package:silverapp/roles/driver/helpers/alert_end_trip.dart';

void main() {
  group('Function calculateFraction', () {
    Function function = calculateMinBasePrice;

    List<Map<String, dynamic>> values = [
      {
        "totalPrice": 5.0,
        "serviceCarType": "CAR",
        "reserveStartTime": DateTime(2024, 4, 29, 14, 0),
        "result": 20
      },
      {
        "totalPrice": 5.0,
        "serviceCarType": "CAR",
        "reserveStartTime": DateTime(2024, 4, 29, 9, 0),
        "result": 22
      },
      {
        "totalPrice": 5.0,
        "serviceCarType": "TRUCK",
        "reserveStartTime": DateTime(2024, 4, 29, 14, 0),
        "result": 25
      },
      {
        "totalPrice": 5.0,
        "serviceCarType": "TRUCK",
        "reserveStartTime": DateTime(2024, 4, 29, 9, 0),
        "result": 27.5
      },
      {
        "totalPrice": 5.0,
        "serviceCarType": "VAN",
        "reserveStartTime": DateTime(2024, 4, 29, 14, 0),
        "result": 90
      },
      {
        "totalPrice": 5.0,
        "serviceCarType": "VAN",
        "reserveStartTime": DateTime(2024, 4, 29, 9, 0),
        "result": 99
      },
    ];

    for (var element in values) {
      test(
          'Function index: ${values.indexOf(element)}, totalPrice: ${element['totalPrice']}, serviceCarType: ${element['serviceCarType']}, reserveStartTime: ${element['reserveStartTime']} , result: ${element['result']}',
          () {
        expect(
            function(element['totalPrice'], element['serviceCarType'],
                element['reserveStartTime']),
            element['result']);
        expect(
            function(element['totalPrice'], element['serviceCarType'],
                element['reserveStartTime']),
            isA<double>());
      });
    }
  });
}
