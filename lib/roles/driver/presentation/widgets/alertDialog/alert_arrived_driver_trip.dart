import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_state_provider.dart';
import '../../../../../config/dio/dio.dart';

class AlertArrivedDriver extends StatefulWidget {
  final int tripId;

  const AlertArrivedDriver({
    super.key,
    required this.tripId,
  });

  @override
  State<AlertArrivedDriver> createState() => _AlertTripStartState();
}

class _AlertTripStartState extends State<AlertArrivedDriver> {
  void patchArrivedDrive(BuildContext context, int tripId) async {
    try {
      final BuildContext currentContext = context;
      print(tripId);
      await dio.patch('trips/$tripId',
          data: {"arrivedDriver": DateTime.now().toIso8601String()});
      /*  ref
          .read(tripDriverStatusProvider.notifier)
          .loadTripState(widget.tripId.toString()); */
      Navigator.of(currentContext).pop();
    } catch (e) {
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
                onPressed: () async {
                  patchArrivedDrive(context, widget.tripId);
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ),
        ])
      ],
    );
  }
}
