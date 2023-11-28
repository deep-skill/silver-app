import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlertDefault extends StatefulWidget {
  const AlertDefault({super.key});

  @override
  State<AlertDefault> createState() => _AlertDefaulState();
}

class _AlertDefaulState extends State<AlertDefault> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Error al ingresar dato"),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
