import 'package:flutter/material.dart';

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
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF23A5CD),
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
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Color(0xFF23A5CD)))),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ),
        ])
      ],
    );
  }
}
