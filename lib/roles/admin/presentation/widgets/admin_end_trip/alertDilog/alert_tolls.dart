import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_end_detail.dart';

class AlertToll extends StatefulWidget {
  final Function(String, double, double, double) addToll;
  final List<String> dropdownItems;
  final List<TollMap> tollMapItems;
  const AlertToll(
      {Key? key,
      required this.dropdownItems,
      required this.addToll,
      required this.tollMapItems})
      : super(key: key);

  @override
  State<AlertToll> createState() => _AlertPeajeState();
}

class _AlertPeajeState extends State<AlertToll> {
  final TextEditingController _controller = TextEditingController();
  List<TollMap> tollMapItems = [];

  String? selectedDropdownValue = "Selecciona el peaje";

  @override
  void initState() {
    super.initState();
  }

  TollMap getTollMap(String? tollName) {
    if (tollName == "Selecciona el peaje") {
      context.pop();
    }
    if (tollName == "Error al obtener datos") {
      context.pop();
    }
    return widget.tollMapItems.firstWhere((toll) => toll.name == tollName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.paid_outlined),
          Text("Peaje"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: DropdownButton<String>(
              underline: const SizedBox(),
              dropdownColor: Colors.grey[200],
              focusColor: Colors.grey[200],
              isExpanded: true,
              isDense: false,
              style: const TextStyle(
                color: Colors.black,
              ),
              menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
              value: selectedDropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  selectedDropdownValue = newValue;
                });
              },
              items: widget.dropdownItems.map((String toll) {
                return DropdownMenuItem<String>(
                  value: toll,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 3,
                      ),
                      Text(toll),
                    ],
                  ),
                );
              }).toList(),
            ),
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
                onPressed: () {
                  TollMap toll = getTollMap(selectedDropdownValue);
                  widget.addToll(toll.name, toll.amount, toll.lat, toll.lon);
                  _controller.clear();
                  context.pop();
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
      ],
    );
  }
}
