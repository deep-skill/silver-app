import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/roles/driver/presentation/widgets/async_buttons/async_driver_in_trip_button.dart';

class AlertTripCanceled extends StatefulWidget {
  final int tripId;
  final VoidCallback reload;
  final VoidCallback cancelReload;
  final String credentials;
  final String serviceCarType;
  const AlertTripCanceled({
    Key? key,
    required this.tripId,
    required this.cancelReload,
    required this.reload,
    required this.credentials,
    required this.serviceCarType,
  }) : super(key: key);
  @override
  State<AlertTripCanceled> createState() => _AlertTripEndState();
}

class _AlertTripEndState extends State<AlertTripCanceled> {
  double calculateNoSwow() {
    if (widget.serviceCarType == "TRUCK") return 25.0;
    if (widget.serviceCarType == "VAN") return 50.0;
    return 20.0;
  }

  void canceledTripDriver(int tripId, String credentials) async {
    try {
      await dio(credentials).patch('trips/driver-trip/$tripId',
          data: {"status": "CANCELED", "totalPrice": calculateNoSwow()});
      widget.cancelReload();
      widget.reload();
    } catch (e) {
      print(e);
      context.go("/driver/error-server");
    }
  }

  Future<bool?> onPressed() async {
    try {
      canceledTripDriver(widget.tripId, widget.credentials);
      return true;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cancelar viaje por no show"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("El pasajero no se presentó."),
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
