import 'package:flutter/material.dart';

class AlertTripStart extends StatefulWidget {
  const AlertTripStart({super.key});

  @override
  State<AlertTripStart> createState() => _AlertTripStartState();
}

class _AlertTripStartState extends State<AlertTripStart> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Esta seguro qe deseas iniciar viaje?"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Marcar esta opcion solo si ya vas a iniciar el viaje"),
          // Agrega más widgets según tus necesidades
        ],
      ),
      actions: <Widget>[
        Row(children: [
          Expanded(
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF23A5CD),
                ),
                onPressed: () {},
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
