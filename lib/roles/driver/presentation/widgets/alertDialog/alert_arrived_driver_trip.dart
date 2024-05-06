import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/roles/driver/helpers/datatime_rouded_string.dart';
import 'package:silverapp/roles/driver/presentation/widgets/async_buttons/async_driver_in_trip_button.dart';

class AlertArrivedDriver extends StatefulWidget {
  final int tripId;
  final String credentials;
  final VoidCallback reload;
  const AlertArrivedDriver({
    Key? key,
    required this.tripId,
    required this.reload,
    required this.credentials,
  }) : super(key: key);

  @override
  State<AlertArrivedDriver> createState() => _AlertTripStartState();
}

class _AlertTripStartState extends State<AlertArrivedDriver> {
  void patchArrivedDriver(int tripId) async {
    try {
      await dio(widget.credentials).patch('trips/driver-trip/$tripId',
          data: {"arrivedDriver": roudedDateTimeToString()});
      widget.reload();
    } catch (e) {
      print(e);
      context.go("/driver/error-server/${e.toString()}");
    }
  }

  Future<bool?> onPressed() async {
    try {
      patchArrivedDriver(widget.tripId);
      return true;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("¿Llegaste al punto de recojo?"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Marca esta opción solo si estás esperando al pasajero"),
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
