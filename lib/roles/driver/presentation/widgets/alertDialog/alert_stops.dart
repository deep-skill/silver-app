import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlertStops extends StatefulWidget {
  final Function(String) addStops;

  const AlertStops(this.addStops, {super.key});

  @override
  State<AlertStops> createState() => _AlertParadasState();
}

class _AlertParadasState extends State<AlertStops> {
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
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(5)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF23A5CD)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  onPressed: () {
                    widget.addStops(_controller.text);
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
            ],
          ),
        ),
      ],
    );
  }
}
