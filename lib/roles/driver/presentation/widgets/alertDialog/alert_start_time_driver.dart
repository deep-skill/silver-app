import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/roles/driver/helpers/datatime_rouded_string.dart';
import 'package:silverapp/roles/driver/presentation/widgets/async_buttons/async_driver_in_trip_button.dart';

class AlertStartTimeDriver extends StatefulWidget {
  final int tripId;
  final VoidCallback reload;
  final String credentials;
  const AlertStartTimeDriver({
    Key? key,
    required this.tripId,
    required this.reload,
    required this.credentials,
  }) : super(key: key);

  @override
  State<AlertStartTimeDriver> createState() => _AlertTripStartState();
}

class _AlertTripStartState extends State<AlertStartTimeDriver> {
  void patchStartTripDrive(int tripId) async {
    try {
      await dio(widget.credentials).patch('trips/driver-trip/$tripId',
          data: {"startTime": roudedDateTimeToString()});
      widget.reload();
    } catch (e) {
      print(e);
      context.go("/driver/error-server/${e.toString()}");
    }
  }

  Future<bool?> onPressed() async {
    try {
      patchStartTripDrive(widget.tripId);
      return true;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("¿Listo para iniciar el viaje?"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Marcar esta opción para iniciar el viaje con el pasajero"),
        ],
      ),
      actions: <Widget>[
        Row(children: [
          Expanded(
              child: ButtonAsyncDriverInTrip(
            onPressed: onPressed,
          )),
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
