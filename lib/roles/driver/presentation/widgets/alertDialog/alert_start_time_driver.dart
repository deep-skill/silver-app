import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio_request.dart';

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
  void patchStartTripDrive(BuildContext context, int tripId) async {
    try {
      await dio(widget.credentials).patch('trips/driver-trip/$tripId',
          data: {"startTime": DateTime.now().toUtc().toIso8601String()});
      widget.reload();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("¿Está seguro qe deseas iniciar viaje?"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Marcar esta opcion solo si ya vas a iniciar el viaje"),
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
                  patchStartTripDrive(context, widget.tripId);
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
