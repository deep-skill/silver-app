import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio_request.dart';

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
  void patchArrivedDriver(
      BuildContext context, int tripId, String credentials) async {
    try {
      await dio(credentials).patch('trips/driver-trip/$tripId',
          data: {"arrivedDriver": DateTime.now().toUtc().toIso8601String()});
      widget.reload();
    } catch (e) {
      print(e);
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
                onPressed: () async {
                  patchArrivedDriver(
                      context, widget.tripId, widget.credentials);
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
