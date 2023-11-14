import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio.dart';

class AlertStartTimeDriver extends StatefulWidget {
  final int tripId;
  final VoidCallback reload;
  const AlertStartTimeDriver({
    Key? key,
    required this.tripId,
    required this.reload,
  }) : super(key: key);

  @override
  State<AlertStartTimeDriver> createState() => _AlertTripStartState();
}

class _AlertTripStartState extends State<AlertStartTimeDriver> {
  void patchStartTripDrive(BuildContext context, int tripId) async {
    try {
      await dio.patch('trips/$tripId',
          data: {"startTime": DateTime.now().toIso8601String()});
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
      title: const Text("Esta seguro qe deseas iniciar viaje?"),
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
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF23A5CD),
                ),
                onPressed: () => patchStartTripDrive(context, widget.tripId),
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
