import 'package:flutter/material.dart';

class AlertDefaul extends StatefulWidget {
  const AlertDefaul({super.key});

  @override
  State<AlertDefaul> createState() => _AlertDefaulState();
}

class _AlertDefaulState extends State<AlertDefaul> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Error al ingresar dato"),
          // Agrega más widgets según tus necesidades
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
        // Agrega más botones o acciones según tus necesidades
      ],
    );
  }
}
