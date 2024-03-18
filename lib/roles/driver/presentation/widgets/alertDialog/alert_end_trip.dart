import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio_request.dart';

class AlertTripEnd extends StatefulWidget {
  final int tripId;
  final VoidCallback reload;
  final String tripType;
  final DateTime? arrivedDriver;
  final double totalPrice;
  final String credentials;
  final DateTime? startTime;
  final DateTime reserveStartTime;

  const AlertTripEnd({
    Key? key,
    required this.tripId,
    required this.reload,
    required this.tripType,
    required this.arrivedDriver,
    required this.totalPrice,
    required this.credentials,
    required this.startTime,
    required this.reserveStartTime,
  }) : super(key: key);
  @override
  State<AlertTripEnd> createState() => _AlertTripEndState();
}

String getDifferenceBetweenTimes(DateTime arrivedDriver, DateTime tripEnded) {
  Duration difference = tripEnded.difference(arrivedDriver);
  int minutes = difference.inMinutes;
  int seconds = difference.inSeconds % 60;
  String formattedMinutes = minutes.toString().padLeft(2, '0');
  String formattedSeconds = seconds.toString().padLeft(2, '0');
  return '$formattedMinutes:$formattedSeconds';
}

class _AlertTripEndState extends State<AlertTripEnd> {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  double calculateWaitingAmount(
      DateTime? arrivedDriver, DateTime? startTime, DateTime reserveStartTime) {
    DateTime calculateDifferenceTime = reserveStartTime;

    Duration driverDelay = reserveStartTime.difference(arrivedDriver!);
    if (driverDelay.inMinutes < 0) {
      calculateDifferenceTime = arrivedDriver;
    }
    Duration difference = startTime!.difference(calculateDifferenceTime);

    if (difference.inMinutes >= 15) {
      return (difference.inMinutes.toDouble() - 15) * 0.5;
    }
    return 0.0;
  }

  double calculateFraction(int time) {
    double result = 0.0;
    int hourComplete = time ~/ 60;
    int minuteComplete = (time % 60).toInt();
    if (minuteComplete == 0) {
      result = hourComplete.toDouble();
    }
    if (minuteComplete < 30 && minuteComplete > 0) {
      result = hourComplete.toDouble() + 0.5;
    }
    if (minuteComplete >= 30) {
      result = hourComplete.toDouble() + 1.0;
    }
    return result;
  }

  void sendEventTripEnded(String tripTimeMinutes) {
    analytics.logEvent(
        name: 'driver_trip_ended',
        parameters: <String, dynamic>{'trip_time_minutes': tripTimeMinutes});
  }

  double totalPricePerHour(DateTime arrivedDriver) {
    final diferencia = DateTime.now().difference(arrivedDriver);
    if (diferencia.inMinutes <= 60) {
      return 1;
    } else {
      return calculateFraction(diferencia.inMinutes);
    }
  }

  void patchEndTripDrive(BuildContext context, int tripId) async {
    try {
      if (widget.tripType == "POR HORA") {
        await dio(widget.credentials).patch('trips/driver-trip/$tripId', data: {
          "endTime": DateTime.now().toUtc().toIso8601String(),
          "status": "COMPLETED",
          "totalPrice":
              totalPricePerHour(widget.arrivedDriver!) * widget.totalPrice
        });
      } else if (calculateWaitingAmount(
              widget.arrivedDriver, widget.startTime, widget.reserveStartTime) >
          0) {
        await dio(widget.credentials).patch('trips/driver-trip/$tripId', data: {
          "endTime": DateTime.now().toUtc().toIso8601String(),
          "status": "COMPLETED",
          "totalPrice": widget.totalPrice +
              calculateWaitingAmount(widget.arrivedDriver, widget.startTime,
                  widget.reserveStartTime),
          "waitingTimeExtra": calculateWaitingAmount(widget.arrivedDriver,
                  widget.startTime, widget.reserveStartTime)
              .toDouble()
        });
      } else {
        await dio(widget.credentials).patch('trips/driver-trip/$tripId', data: {
          "endTime": DateTime.now().toUtc().toIso8601String(),
          "status": "COMPLETED"
        });
      }
      widget.reload();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("¿Deseas finalizar viaje y enviar datos?"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Confirmar para enviar datos. No se podrán editar luego"),
        ],
      ),
      actions: <Widget>[
        Row(children: [
          Expanded(
            child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(5)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF23A5CD)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                onPressed: () {
                  patchEndTripDrive(context, widget.tripId);
                  final DateTime? startTime = widget.arrivedDriver;

                  if (startTime != null) {
                    final String minutes =
                        getDifferenceBetweenTimes(startTime, DateTime.now());
                    sendEventTripEnded(minutes);
                  }

                  context.pop();
                },
                child: const Text(
                  "Confirmar",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "Monserrat"),
                )),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Color(0xFF23A5CD)))),
              onPressed: () => context.pop(),
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Color(0xFF23A5CD)),
              ),
            ),
          ),
        ])
      ],
    );
  }
}
