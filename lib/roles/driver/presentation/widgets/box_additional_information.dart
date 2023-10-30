import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_Toll.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_defaut.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_observations.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_parkin_lot.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_stops.dart';
import 'package:silverapp/roles/driver/presentation/widgets/label_trip_extra.dart';
import 'package:silverapp/roles/driver/presentation/widgets/title_additional_information.dart';

class AdditionalInformacion extends StatefulWidget {
  final bool boolValue;
  const AdditionalInformacion({super.key, required this.boolValue});

  @override
  State<AdditionalInformacion> createState() => _AdditionalInformacionState();
}

class _AdditionalInformacionState extends State<AdditionalInformacion> {
  String selectedOption = 'Seleccionar item'; // Opción predeterminada
  List<String> stops = [];
  List<String> observations = [];
  List<String> parkingLot = [];
  List<String> tolls = [];

  List<String> options = [
    'Seleccionar item',
    'Peaje',
    'Paradas',
    'Estacionamiento',
    'Observaciones'
  ];

  void removeStop(int index) {
    setState(() {
      stops.removeAt(index);
    });
  }

  void remObservations(int index) {
    setState(() {
      observations.removeAt(index);
    });
  }

  void remParkingLot(int index) {
    setState(() {
      parkingLot.removeAt(index);
    });
  }

  void remTolls(int index) {
    setState(() {
      tolls.removeAt(index);
    });
  }

  void addTools(String toll) {
    setState(() {
      tolls.add(toll);
    });
  }

  void addParkingLot(String parking) {
    setState(() {
      parkingLot.add(parking);
    });
  }

  void addObservations(String observation) {
    setState(() {
      observations.add(observation);
    });
  }

  void addStops(String stop) {
    setState(() {
      stops.add(stop);
    });
  }

  void _showCustomDialog(String option) {
    showDialog(
      context: context,
      builder: (context) {
        switch (option) {
          case 'Peaje':
            return AletToll(addTools);
          case 'Paradas':
            return AletStops(addStops);
          case "Observaciones":
            return AletObservations(addObservations);
          case "Estacionamiento":
            return AletParking(addParkingLot);
          default:
            return const AlertDefaul();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool boolValue = widget.boolValue;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          (boolValue)
              ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: DropdownButton<String>(
                    underline: const SizedBox(),
                    dropdownColor: Colors.white,
                    focusColor: Colors.white,
                    isExpanded: true,
                    isDense: false,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                    menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                    value: selectedOption,
                    items: options.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Text(option),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOption = newValue ?? '';
                        // Llama al método para mostrar el diálogo
                        if (selectedOption != 'Seleccionar item') {
                          _showCustomDialog(selectedOption);
                        }
                      });
                    },
                  ),
                )
              : const SizedBox(),
          const TitleAdditionalInformation(
            icon: Icons.add_location_alt_outlined,
            label: "Parada",
          ),
          Column(
            children: stops.asMap().entries.map((entry) {
              final index = entry.key;
              final stop = entry.value;

              return CustomCard(
                text: stop,
                onPressed: () {
                  removeStop(index);
                },
              );
            }).toList(),
          ),
          const TitleAdditionalInformation(
            icon: Icons.paid_outlined,
            label: "Peaje",
          ),
          Column(
            children: tolls.asMap().entries.map((entry) {
              final index = entry.key;
              final tolls = entry.value;

              return CustomCard(
                text: tolls,
                onPressed: () {
                  remTolls(index);
                },
              );
            }).toList(),
          ),
          const TitleAdditionalInformation(
            icon: Icons.local_parking,
            label: "Estacionamiento",
          ),
          Column(
            children: parkingLot.asMap().entries.map((entry) {
              final index = entry.key;
              final parkingLot = entry.value;

              return CustomCard(
                text: parkingLot,
                onPressed: () {
                  remParkingLot(index);
                },
              );
            }).toList(),
          ),
          const TitleAdditionalInformation(
            icon: Icons.search,
            label: "Obsercaviones",
          ),
          Column(
              children: observations.asMap().entries.map((entry) {
            final index = entry.key;
            final observations = entry.value;

            return CustomCard(
              text: observations,
              onPressed: () {
                remObservations(index);
              },
            );
          }).toList())
        ],
      ),
    );
  }
}
