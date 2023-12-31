import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AlertParking extends StatefulWidget {
  final Function(String, double) addParking;

  const AlertParking(this.addParking, {super.key});

  @override
  State<AlertParking> createState() => _AlertParadasState();
}

class _AlertParadasState extends State<AlertParking> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerInput = TextEditingController();

  final InputDecoration _inputDecoration = const InputDecoration(
      hintText: 'Ingresa descripción',
      contentPadding: EdgeInsets.all(5),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
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

  final InputDecoration _inputDecorationAmout = const InputDecoration(
      hintText: 'S/ 00.00',
      contentPadding: EdgeInsets.all(5),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
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
          Icon(Icons.local_parking),
          Text("Estacionamiento"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            controller: _controllerInput,
            decoration: _inputDecorationAmout,
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: _controller,
            decoration: _inputDecoration,
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF23A5CD)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                onPressed: () {
                  final double? parkingAmount =
                      double.tryParse(_controllerInput.text);
                  if (parkingAmount != null && _controller.text != "") {
                    widget.addParking(_controller.text, parkingAmount);
                    _controller.clear();
                    context.pop();
                  } else {
                    context.pop();
                  }
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
              width: 5,
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
      ],
    );
  }
}
