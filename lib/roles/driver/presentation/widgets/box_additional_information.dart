import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_toll.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_defaut.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_observations.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_parkin_lot.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_stops.dart';
import 'package:silverapp/roles/driver/presentation/widgets/label_trip_extra.dart';
import 'package:silverapp/roles/driver/presentation/widgets/title_additional_information.dart';

class AdditionalInformation extends StatefulWidget {
  final bool boolValue;
  final int tripId;
  final VoidCallback reload;
  final List<Stop> stops;
  final List<Observations> observations;
  final List<Parking> parkings;
  final List<Toll> tolls;

  const AdditionalInformation({
    Key? key,
    required this.boolValue,
    required this.tripId,
    required this.reload,
    required this.stops,
    required this.observations,
    required this.parkings,
    required this.tolls,
  }) : super(key: key);

  @override
  State<AdditionalInformation> createState() => _AdditionalInformationState();
}

class _AdditionalInformationState extends State<AdditionalInformation> {
  String selectedOption = 'Seleccionar item';
  late List<Stop> stops;
  late List<Observations> observations;
  late List<Parking> parkings;
  late List<Toll> tolls;

  @override
  void initState() {
    super.initState();
    selectedOption = 'Seleccionar item';
    stops = List<Stop>.from(widget.stops);
    observations = List<Observations>.from(widget.observations);
    parkings = List<Parking>.from(widget.parkings);
    tolls = List<Toll>.from(widget.tolls);
    fetchDataForDropdown();
  }

  List<String> options = [
    'Seleccionar item',
    'Peaje',
    'Paradas',
    'Estacionamiento',
    'Observaciones'
  ];

  List<String> dropdownItems = ["Seleccionar peaje"];
  List<TollMap> tollMapItems = [];
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

  void addStops(String stop) async {
    try {
      await dio
          .post('stops', data: {"location": stop, "tripId": widget.tripId});
      widget.reload();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void removeStop(int stopId) async {
    try {
      await dio.delete(
        'stops/$stopId',
      );
      widget.reload();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void addObservations(String observation) async {
    try {
      await dio.post('observations',
          data: {"observation": observation, "tripId": widget.tripId});
      widget.reload();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void remObservations(int observationId) async {
    try {
      await dio.delete(
        'observations/$observationId',
      );
      widget.reload();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void addParking(String parking, String amount) async {
    double? amoutDouble = double.tryParse(amount);
    try {
      await dio.post('parkings', data: {
        "name": parking,
        "tripId": widget.tripId,
        "amount": amoutDouble
      });
      widget.reload();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void remParking(int parkingId) async {
    try {
      await dio.delete('parkings/$parkingId');
      widget.reload();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void addTools(String name, double amount, double lat, double lon) async {
    try {
      await dio.post('tolls', data: {
        "tripId": widget.tripId,
        "name": name,
        "amount": amount,
        "lat": lat,
        "lon": lon
      });
      widget.reload();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void remTolls(int tollId) async {
    try {
      await dio.delete('tolls/$tollId');
      widget.reload();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void _showCustomDialog(String option) {
    showDialog(
      context: context,
      builder: (context) {
        switch (option) {
          case 'Peaje':
            return AlertToll(
                addToll: addTools,
                dropdownItems: dropdownItems,
                tollMapItems: tollMapItems);
          case 'Paradas':
            return AlertStops(addStops);
          case "Observaciones":
            return AlertObservations(addObservations);
          case "Estacionamiento":
            return AlertParking(addParking);
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
              final stop = entry.value;
              return CustomCard(
                text: stop.location,
                onPressed: () {
                  removeStop(stop.id);
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
              final toll = entry.value;
              return CustomCard(
                text: toll.name,
                onPressed: () {
                  remTolls(toll.id);
                },
              );
            }).toList(),
          ),
          const TitleAdditionalInformation(
            icon: Icons.local_parking,
            label: "Estacionamiento",
          ),
          Column(
            children: parkings.asMap().entries.map((entry) {
              final parking = entry.value;
              return CustomCard(
                text: parking.name,
                onPressed: () {
                  remParking(parking.id);
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
            final observation = entry.value;
            return CustomCard(
              text: observation.observation,
              onPressed: () {
                remObservations(observation.id);
              },
            );
          }).toList())
        ],
      ),
    );
  }
}
