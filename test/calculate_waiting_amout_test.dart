import 'package:flutter_test/flutter_test.dart';
import 'package:silverapp/roles/driver/helpers/alert_end_trip.dart';

void main() {
  group('Function calculateWaitingAmount', () {
    Function function = calculateWaitingAmount;

// DateTime(aNio mes dia hora minuto segundo)
    List<Map<String, dynamic>> values = [
      //--------------------------------------------------------------
      //cases: driver arrives on time
      //driver arrives at 10:00 and the trip starts at 10:05 without surcharge
      {
        "arrivedDriver": DateTime(2024, 4, 29, 10, 0),
        "startTime": DateTime(2024, 4, 29, 10, 5),
        "reserveStartTime": DateTime(2024, 4, 29, 10, 0),
        "result": 0.0
      },
      //driver arrives at 10:00 and the trip starts at 10:10
      {
        "arrivedDriver": DateTime(2024, 4, 29, 10, 0),
        "startTime": DateTime(2024, 4, 29, 10, 10),
        "reserveStartTime": DateTime(2024, 4, 29, 10, 0),
        "result": 0.0
      },
      //driver arrives at 10:00 and the trip starts at 10:15
      {
        "arrivedDriver": DateTime(2024, 4, 29, 10, 0),
        "startTime": DateTime(2024, 4, 29, 10, 15),
        "reserveStartTime": DateTime(2024, 4, 29, 10, 0),
        "result": 0.0
      },
      //driver arrives at 10:00 and the trip starts at 10:20
      {
        "arrivedDriver": DateTime(2024, 4, 29, 10, 0),
        "startTime": DateTime(2024, 4, 29, 10, 20),
        "reserveStartTime": DateTime(2024, 4, 29, 10, 0),
        "result": 2.5
      },
      //driver arrives at 10:00 and the trip starts at 10:30
      {
        "arrivedDriver": DateTime(2024, 4, 29, 10, 0),
        "startTime": DateTime(2024, 4, 29, 10, 30),
        "reserveStartTime": DateTime(2024, 4, 29, 10, 0),
        "result": 7.5
      },
      //--------------------------------------------------------------
      //cases: driver is late
      //driver arrives at 10:05 and the trip starts at 10:15 without surcharge (wait 10 min)
      {
        "arrivedDriver": DateTime(2024, 4, 29, 10, 5),
        "startTime": DateTime(2024, 4, 29, 10, 15),
        "reserveStartTime": DateTime(2024, 4, 29, 10, 0),
        "result": 0.0
      },
      //driver arrives at 10:05 and the trip starts at 10:20
      {
        "arrivedDriver": DateTime(2024, 4, 29, 10, 5),
        "startTime": DateTime(2024, 4, 29, 10, 20),
        "reserveStartTime": DateTime(2024, 4, 29, 10, 0),
        "result": 0.0
      },
      //driver arrives at 10:05 and the trip starts at 10:30 surcharge (wait 10 min)
      {
        "arrivedDriver": DateTime(2024, 4, 29, 10, 5),
        "startTime": DateTime(2024, 4, 29, 10, 30),
        "reserveStartTime": DateTime(2024, 4, 29, 10, 0),
        "result": 5.0
      },
      //driver arrives at 10:05 and the trip starts at 10:25 surcharge (wait 5 min)
      {
        "arrivedDriver": DateTime(2024, 4, 29, 10, 5),
        "startTime": DateTime(2024, 4, 29, 10, 25),
        "reserveStartTime": DateTime(2024, 4, 29, 10, 0),
        "result": 2.5
      },
      //driver arrives at 10:05 and the trip starts at 10:40 surcharge (wait 20 min)
      {
        "arrivedDriver": DateTime(2024, 4, 29, 10, 5),
        "startTime": DateTime(2024, 4, 29, 10, 40),
        "reserveStartTime": DateTime(2024, 4, 29, 10, 0),
        "result": 10
      },
      //--------------------------------------------------------------
      //case: driver arrives early
      //driver arrives at 9:50 and the trip starts at 10:10
      // reservation time is taken (10:00) for arriving earlier. Waiting time 10 min
      {
        "arrivedDriver": DateTime(2024, 4, 29, 9, 50),
        "startTime": DateTime(2024, 4, 29, 10, 10),
        "reserveStartTime": DateTime(2024, 4, 29, 10, 0),
        "result": 0.0
      },
      //driver arrives at 9:50 and the trip starts at 10:20.  Waiting time 5 min
      {
        "arrivedDriver": DateTime(2024, 4, 29, 9, 50),
        "startTime": DateTime(2024, 4, 29, 10, 20),
        "reserveStartTime": DateTime(2024, 4, 29, 10, 0),
        "result": 2.5
      },
      //driver arrives at 9:50 and the trip starts at 10:20.  Waiting time 10 min
      {
        "arrivedDriver": DateTime(2024, 4, 29, 9, 50),
        "startTime": DateTime(2024, 4, 29, 10, 25),
        "reserveStartTime": DateTime(2024, 4, 29, 10, 0),
        "result": 5.0
      },
      //driver arrives at 9:50 and the trip starts at 10:20.  Waiting time 20 min
      {
        "arrivedDriver": DateTime(2024, 4, 29, 9, 50),
        "startTime": DateTime(2024, 4, 29, 10, 40),
        "reserveStartTime": DateTime(2024, 4, 29, 10, 0),
        "result": 12.5
      },
    ];

    for (var element in values) {
      test(
          'Function index: ${values.indexOf(element)}, arrivedDriver: ${element['arrivedDriver']}, startTime: ${element['startTime']}, reserveStartTime: ${element['reserveStartTime']} , result: ${element['result']}}',
          () {
        expect(
            function(element['arrivedDriver'], element['startTime'],
                element['reserveStartTime']),
            element['result']);
        expect(
            function(element['arrivedDriver'], element['startTime'],
                element['reserveStartTime']),
            isA<double>());
      });
    }
  });
}
