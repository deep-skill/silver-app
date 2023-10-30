import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/presentation/screens/driver_screen_trip_end.dart';

class AlertTripEnd extends StatefulWidget {
  const AlertTripEnd({super.key});

  @override
  State<AlertTripEnd> createState() => _AlertTripEndState();
}

class _AlertTripEndState extends State<AlertTripEnd> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Desea finalizar viaje y enviar datos?"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Luego no podras volver a editar datos"),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScreemTripEnd()),
                  );
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
