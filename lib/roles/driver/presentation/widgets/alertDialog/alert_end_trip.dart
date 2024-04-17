import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/google_maps/google_post_routes.dart';
import 'package:silverapp/roles/driver/helpers/alert_end_trip.dart';
import 'package:silverapp/roles/driver/helpers/datatime_rouded_string.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';
import 'package:silverapp/roles/driver/presentation/widgets/async_buttons/async_driver_in_trip_button.dart';

class AlertTripEnd extends StatefulWidget {
  final int tripId;
  final VoidCallback reload;
  final String tripType;
  final DateTime? arrivedDriver;
  final double totalPrice;
  final String credentials;
  final DateTime? startTime;
  final DateTime reserveStartTime;
  final String serviceCarType;
  final double startAddressLat;
  final double startAddressLon;
  final double? endAddressLat;
  final double? endAddressLon;
  final List<Stop> stops;

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
    required this.serviceCarType,
    required this.startAddressLat,
    required this.startAddressLon,
    required this.endAddressLat,
    required this.endAddressLon,
    required this.stops,
  }) : super(key: key);
  @override
  State<AlertTripEnd> createState() => _AlertTripEndState();
}

class _AlertTripEndState extends State<AlertTripEnd> {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  void sendEventTripEnded(String tripTimeMinutes) {
    analytics.logEvent(
        name: 'driver_trip_ended',
        parameters: <String, dynamic>{'trip_time_minutes': tripTimeMinutes});
  }

  void patchEndTripDrive(int tripId) async {
    try {
      //case: "trip per hour" edits endTime, trip status and total price
      if (widget.tripType == "POR HORA") {
        await dio(widget.credentials).patch('trips/driver-trip/$tripId', data: {
          "endTime": roudedDateTimeToString(),
          "status": "COMPLETED",
          "totalPrice": totalPricePerHour(widget.arrivedDriver!,
                  widget.reserveStartTime, widget.serviceCarType) *
              widget.totalPrice
        });
        widget.reload();
        return;
      }
      //case: "by point without stops", state and endTime are edited
      final waitingAmout = calculateWaitingAmount(
          widget.arrivedDriver, widget.startTime, widget.reserveStartTime);

      if (widget.stops.isEmpty) {
        if (waitingAmout > 0) {
          await dio(widget.credentials)
              .patch('trips/driver-trip/$tripId', data: {
            "endTime": roudedDateTimeToString(),
            "status": "COMPLETED",
            "waitingTimeExtra": waitingAmout.toDouble(),
          });
          widget.reload();
          return;
        }
        await dio(widget.credentials).patch('trips/driver-trip/$tripId', data: {
          "endTime": roudedDateTimeToString(),
          "status": "COMPLETED",
        });
        widget.reload();
        return;
      }

      //case: "point to point with stops"
      var suggestedTotalPrice = 0;

      var route = await calculateRouteAndStops(getDirectionsUrl(
          widget.startAddressLat,
          widget.startAddressLon,
          widget.endAddressLat,
          widget.endAddressLon,
          widget.stops));

      suggestedTotalPrice = calculateBasePrice(
          route.distance,
          route.time,
          widget.serviceCarType,
          isInDesiredTimeRange(widget.startTime.toString()));

      if (waitingAmout > 0) {
        await dio(widget.credentials).patch('trips/driver-trip/$tripId', data: {
          "endTime": roudedDateTimeToString(),
          "status": "COMPLETED",
          "waitingTimeExtra": waitingAmout.toDouble(),
          "totalPrice": suggestedTotalPrice,
          "suggestedTotalPrice": widget.totalPrice,
          "polyline": route.encodedPolyline
        });
      } else {
        await dio(widget.credentials).patch('trips/driver-trip/$tripId', data: {
          "endTime": roudedDateTimeToString(),
          "status": "COMPLETED",
          "totalPrice": suggestedTotalPrice,
          "suggestedTotalPrice": widget.totalPrice,
          "tripPolyline": route.encodedPolyline
        });
      }
      widget.reload();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<bool?> onPressed() async {
    try {
      patchEndTripDrive(widget.tripId);
      return true;
    } catch (e) {
      return null;
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
            child: ButtonAsyncDriverInTrip(
              onPressed: onPressed,
            ),
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
