import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio.dart';

class AlertTripEnd extends StatefulWidget {
  final int tripId;
  final VoidCallback reload;
  const AlertTripEnd({
    Key? key,
    required this.tripId,
    required this.reload,
  }) : super(key: key);
  @override
  State<AlertTripEnd> createState() => _AlertTripEndState();
}

class _AlertTripEndState extends State<AlertTripEnd> {
  void patchEndTripDrive(BuildContext context, int tripId) async {
    try {
      await dio.patch('trips/driver-trip/$tripId', data: {
        "endTime": DateTime.now().toIso8601String(),
        "status": "COMPLETED"
      });
      widget.reload();
      context.pop();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Desea finalizar viaje y enviar datos?"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Luego no podras volver a editar datos"),
        ],
      ),
      actions: <Widget>[
        Row(children: [
          Expanded(
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF23A5CD),
                ),
                onPressed: () => patchEndTripDrive(context, widget.tripId),
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
