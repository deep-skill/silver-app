import 'package:flutter/material.dart';

class AletStops extends StatefulWidget {
  final Function(String) onTextoAgregado;

  AletStops(this.onTextoAgregado);

  @override
  State<AletStops> createState() => _AletParadasState();
}

class _AletParadasState extends State<AletStops> {
  final TextEditingController _controller = TextEditingController();

  final InputDecoration _inputDecoration = const InputDecoration(
      labelText: 'Ingresar Parada',
      contentPadding: EdgeInsets.all(5),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Colors.black), // Borde negro al enfocar el campo
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.add_location_alt_outlined),
          Text("Parada"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: _inputDecoration,
          ),
          // Agrega más widgets según tus necesidades
        ],
      ),
      actions: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF23A5CD),
                  ),
                  onPressed: () {
                    widget.onTextoAgregado(_controller.text);
                    _controller.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Agregar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Monserrat"),
                  ),
                ),
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
            ],
          ),
        ),
        // Agrega más botones o acciones según tus necesidades
      ],
    );
  }
}
