import 'package:flutter_test/flutter_test.dart';
import 'package:silverapp/roles/driver/helpers/alert_end_trip.dart';

void main() {
  group('Function totalPricePerHour', () {
    Function function = totalPricePerHour;

    List<Map<String, dynamic>> values = [
      //case: CAR / TRUCK
      {
        "arrivedDriver": DateTime.now().subtract(const Duration(minutes: 100)),
        "reserveStartTime":
            DateTime.now().subtract(const Duration(minutes: 90)),
        "serviceCarType": 'CAR',
        "result": 2.0
      },
      {
        "arrivedDriver": DateTime.now().subtract(const Duration(minutes: 50)),
        "reserveStartTime":
            DateTime.now().subtract(const Duration(minutes: 50)),
        "serviceCarType": 'CAR',
        "result": 2.0
      },
      {
        "arrivedDriver": DateTime.now().subtract(const Duration(minutes: 130)),
        "reserveStartTime":
            DateTime.now().subtract(const Duration(minutes: 120)),
        "serviceCarType": 'CAR',
        "result": 2.0
      },
      //driver arrives early
      {
        "arrivedDriver": DateTime.now().subtract(const Duration(minutes: 240)),
        "reserveStartTime":
            DateTime.now().subtract(const Duration(minutes: 120)),
        "serviceCarType": 'CAR',
        "result": 2.0
      },
      {
        "arrivedDriver": DateTime.now().subtract(const Duration(minutes: 240)),
        "reserveStartTime":
            DateTime.now().subtract(const Duration(minutes: 150)),
        "serviceCarType": 'CAR',
        "result": 2.5
      },
      {
        "arrivedDriver": DateTime.now().subtract(const Duration(minutes: 240)),
        "reserveStartTime":
            DateTime.now().subtract(const Duration(minutes: 180)),
        "serviceCarType": 'CAR',
        "result": 3.0
      },
      {
        "arrivedDriver": DateTime.now().subtract(const Duration(minutes: 240)),
        "reserveStartTime":
            DateTime.now().subtract(const Duration(minutes: 170)),
        "serviceCarType": 'CAR',
        "result": 3.0
      },
      {
        "arrivedDriver": DateTime.now().subtract(const Duration(minutes: 120)),
        "reserveStartTime":
            DateTime.now().subtract(const Duration(minutes: 120)),
        "serviceCarType": 'VAN',
        "result": 4.0
      },
      {
        "arrivedDriver": DateTime.now().subtract(const Duration(minutes: 180)),
        "reserveStartTime":
            DateTime.now().subtract(const Duration(minutes: 180)),
        "serviceCarType": 'VAN',
        "result": 4.0
      },
      {
        "arrivedDriver": DateTime.now().subtract(const Duration(minutes: 300)),
        "reserveStartTime":
            DateTime.now().subtract(const Duration(minutes: 300)),
        "serviceCarType": 'VAN',
        "result": 5.0
      },
    ];

    for (var element in values) {
      test(
          'Function index: ${values.indexOf(element)}, arrivedDriver: ${element['arrivedDriver']}, startTime: ${element['reserveStartTime']} , serviceCarType: ${element['serviceCarType']} ,"result": ${element['result']}.',
          () {
        expect(
            function(element['arrivedDriver'], element['reserveStartTime'],
                element['serviceCarType']),
            element['result']);
        expect(
            function(element['arrivedDriver'], element['reserveStartTime'],
                element['serviceCarType']),
            isA<double>());
      });
    }
  });
}
