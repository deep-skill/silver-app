import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlertTripCanceled extends StatefulWidget {
  const AlertTripCanceled({super.key});

  @override
  State<AlertTripCanceled> createState() => _AlertTripCanceledState();
}

class _AlertTripCanceledState extends State<AlertTripCanceled> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cancelar viaje por no show"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("El pasajero no se presento."),
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
                onPressed: null,
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
