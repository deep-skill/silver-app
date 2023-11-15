import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';

class AlertToll extends StatefulWidget {
  final Function(String, double, double, double) addToll;

  const AlertToll(this.addToll, {super.key});

  @override
  State<AlertToll> createState() => _AlertPeajeState();
}

class _AlertPeajeState extends State<AlertToll> {
  final TextEditingController _controller = TextEditingController();
  List<String> dropdownItems = ["Seleccionar peaje"];
  List<TollMap> tollMapItems = [];

  String? selectedDropdownValue = "Seleccionar peaje";

  @override
  void initState() {
    super.initState();
    fetchDataForDropdown();
  }

  Future<void> fetchDataForDropdown() async {
    try {
      Response response = await Dio().get(
          'https://faas-nyc1-2ef2e6cc.doserverless.co/api/v1/web/fn-09c30b41-966b-480d-ad0d-e248e9f1a45a/default/tolls');
      List<dynamic> data = response.data as List<dynamic>;
      List<TollMap> tollsMap =
          data.map((item) => TollMap.fromJson(item)).toList();
      List<String> tollsName = tollsMap.map((item) => item.name).toList();
      setState(() {
        dropdownItems = ["Seleccionar peaje", ...tollsName];
        tollMapItems = [...tollsMap];
      });
    } catch (e) {
      setState(() {
        dropdownItems = ["Seleccionar peaje", "Error al obtener datos"];
      });
      print('Error al obtener datos: $e');
    }
  }

  TollMap getTollMap(String? tollName) {
    if (tollName == "Seleccionar peaje") {
      context.pop();
    }
    if (tollName == "Error al obtener datos") {
      context.pop();
    }
    return tollMapItems.firstWhere((toll) => toll.name == tollName);
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
              items: dropdownItems.map((String toll) {
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
                      side: MaterialStateProperty.all(
                          const BorderSide(color: Color(0xFF23A5CD)))),
                  onPressed: () => context.pop(),
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
