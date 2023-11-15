import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio.dart';

class AlertTripDeleted extends StatefulWidget {
  final int tripId;
  final VoidCallback reload;
  const AlertTripDeleted({
    Key? key,
    required this.tripId,
    required this.reload,
  }) : super(key: key);
  @override
  State<AlertTripDeleted> createState() => _AlertTripEndState();
}

class _AlertTripEndState extends State<AlertTripDeleted> {
  void deleteTripDriver(BuildContext context, int tripId) async {
    try {
      await dio.delete('trips/driver-trip/$tripId');
      //widget.reload();
      context.pop("/driver");
    } catch (e) {
      // ignore: avoid_print
      print(e);
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
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF23A5CD),
                ),
                onPressed: () => {
                      deleteTripDriver(context, widget.tripId),
                      context.pop("/driver")
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
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Color(0xFF23A5CD)))),
              onPressed: () => context.pop(),
              child: const Text('Cerrar'),
            ),
          ),
        ])
      ],
    );
  }
}
