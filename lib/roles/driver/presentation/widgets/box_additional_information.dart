// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/google_maps/google_maps_screen.dart';
import 'package:silverapp/google_maps/location_data.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_tolls.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_default.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_observation.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_parkin_lot.dart';
import 'package:silverapp/roles/driver/presentation/widgets/label_trip_extra.dart';
import 'package:silverapp/roles/driver/presentation/widgets/label_trip_extra_end.dart';
import 'package:silverapp/roles/driver/presentation/widgets/title_additional_information.dart';

class AdditionalInformation extends StatefulWidget {
  final bool boolValue;
  final int tripId;
  final String credentials;
  final int reserveId;
  final String tripType;
  final double? waitingTimeExtra;
  final VoidCallback reload;
  final List<Stop> stops;
  final List<Observations> observations;
  final List<Parking> parkings;
  final List<Toll> tolls;

  const AdditionalInformation({
    Key? key,
    required this.boolValue,
    required this.tripId,
    required this.reserveId,
    required this.tripType,
    required this.reload,
    required this.stops,
    required this.observations,
    required this.parkings,
    required this.tolls,
    required this.credentials,
    required this.waitingTimeExtra,
  }) : super(key: key);

  @override
  State<AdditionalInformation> createState() => _AdditionalInformationState();
}

class _AdditionalInformationState extends State<AdditionalInformation> {
  String selectedOption = 'Selecciona ítem';
  late List<Stop> stops;
  late List<Observations> observations;
  late List<Parking> parkings;
  late List<Toll> tolls;

  @override
  void initState() {
    super.initState();
    selectedOption = 'Seleccionar ítem';
    stops = List<Stop>.from(widget.stops);
    observations = List<Observations>.from(widget.observations);
    parkings = List<Parking>.from(widget.parkings);
    tolls = List<Toll>.from(widget.tolls);
    fetchDataForDropdown();
  }

  List<String> options = [
    'Seleccionar ítem',
    'Peaje',
    'Paradas',
    'Estacionamiento',
    'Observaciones'
  ];
  final TextStyle textStyleLastGoodbye = const TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15);

  List<String> dropdownItems = ["Selecciona el peaje"];
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
        dropdownItems = ["Selecciona el peaje", ...tollsName];
        tollMapItems = [...tollsMap];
      });
    } catch (e) {
      setState(() {
        dropdownItems = ["Selecciona el peaje", "Error al obtener datos"];
      });
      context.go("/driver/error-server/${e.toString()}");
    }
  }

  void addStops(String address, double lat, double lon) async {
    try {
      if (widget.tripType == "POR HORA") {
        await dio(widget.credentials)
            .post('reserves/driver-stop/${widget.reserveId}', data: {
          "endAddress": address,
          "endAddressLat": lat,
          "endAddressLon": lon,
          "tripId": widget.tripId
        });
      } else {
        await dio(widget.credentials).post('stops/driver', data: {
          "location": address,
          "lat": lat,
          "lon": lon,
          "tripId": widget.tripId
        });
      }
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/driver/error-server/${e.response!.data['message'].toString()}- uuid error: ${e.response!.data['error'].toString()}");
      widget.reload();
    }
  }

  void removeStop(int stopId) async {
    try {
      await dio(widget.credentials).delete(
        'stops/driver/$stopId',
      );
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/driver/error-server/${e.response!.data['message'].toString()}- uuid error: ${e.response!.data['error'].toString()}");
      widget.reload();
    }
  }

  void addObservations(String observation) async {
    try {
      await dio(widget.credentials).post('observations/driver',
          data: {"observation": observation, "tripId": widget.tripId});
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/driver/error-server/${e.response!.data['message'].toString()}- uuid error: ${e.response!.data['error'].toString()}");
      widget.reload();
    }
  }

  void remObservations(int observationId) async {
    try {
      await dio(widget.credentials).delete(
        'observations/driver/$observationId',
      );
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/driver/error-server/${e.response!.data['message'].toString()}- uuid error: ${e.response!.data['error'].toString()}");
      widget.reload();
    }
  }

  void addParking(String parking, double amount) async {
    try {
      await dio(widget.credentials).post('parkings/driver',
          data: {"name": parking, "tripId": widget.tripId, "amount": amount});
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/driver/error-server/${e.response!.data['message'].toString()}- uuid error: ${e.response!.data['error'].toString()}");
      widget.reload();
    }
  }

  void remParking(int parkingId) async {
    try {
      await dio(widget.credentials).delete('parkings/driver/$parkingId');
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/driver/error-server/${e.response!.data['message'].toString()}- uuid error: ${e.response!.data['error'].toString()}");
      widget.reload();
    }
  }

  void addTolls(String name, double amount, double lat, double lon) async {
    try {
      await dio(widget.credentials).post('tolls/driver', data: {
        "tripId": widget.tripId,
        "name": name,
        "amount": amount,
        "lat": lat,
        "lon": lon
      });
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/driver/error-server/${e.response!.data['message'].toString()}- uuid error: ${e.response!.data['error'].toString()}");
      widget.reload();
    }
  }

  void remTolls(int tollId) async {
    try {
      await dio(widget.credentials).delete('tolls/driver/$tollId');
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/driver/error-server/${e.response!.data['message'].toString()}- uuid error: ${e.response!.data['error'].toString()}");
      widget.reload();
    }
  }

  Future<void> getStop() async {
    LocationData? result;
    result = await Navigator.of(context).push<LocationData>(
      MaterialPageRoute(builder: (context) => const MapGoogle()),
    );
    if (result != null) {
      addStops(result.address, result.latitude, result.longitude);
    }
  }

  void _showCustomDialog(String option) {
    if (option == 'Paradas') {
      getStop();
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        switch (option) {
          case 'Peaje':
            return AlertToll(
                addToll: addTolls,
                dropdownItems: dropdownItems,
                tollMapItems: tollMapItems);
          case "Observaciones":
            return AlertObservations(addObservations);
          case "Estacionamiento":
            return AlertParking(addParking);
          default:
            return const AlertDefault();
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
                        if (selectedOption != 'Seleccionar ítem') {
                          _showCustomDialog(selectedOption);
                        }
                      });
                    },
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: 10),
          const TitleAdditionalInformation(
            icon: Icons.add_location_alt_outlined,
            label: "Parada",
          ),
          const SizedBox(height: 8),
          Column(
            children: stops.asMap().entries.map((entry) {
              final stop = entry.value;
              if (!boolValue) {
                return LabelExtraTripEnd(text: stop.location);
              }
              return LabelExtraTrip(
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
          const SizedBox(height: 8),
          Column(
            children: tolls.asMap().entries.map((entry) {
              final toll = entry.value;
              if (!boolValue) {
                return LabelExtraTripEnd(
                    text: "${toll.name} - S/ ${toll.amount}");
              }
              return LabelExtraTrip(
                text: "${toll.name} - S/ ${toll.amount}",
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
          const SizedBox(height: 8),
          Column(
            children: parkings.asMap().entries.map((entry) {
              final parking = entry.value;
              if (!boolValue) {
                return LabelExtraTripEnd(
                    text: "${parking.name} - S/ ${parking.amount}");
              }
              return LabelExtraTrip(
                text: "${parking.name} - S/ ${parking.amount}",
                onPressed: () {
                  remParking(parking.id);
                },
              );
            }).toList(),
          ),
          const TitleAdditionalInformation(
            icon: Icons.search,
            label: "Observaciones",
          ),
          Column(
              children: observations.asMap().entries.map((entry) {
            final observation = entry.value;
            if (!boolValue) {
              return LabelExtraTripEnd(text: observation.observation);
            }
            return LabelExtraTrip(
              text: observation.observation,
              onPressed: () {
                remObservations(observation.id);
              },
            );
          }).toList()),
          const SizedBox(
            height: 15,
          ),
          widget.waitingTimeExtra != null
              ? const TitleAdditionalInformation(
                  icon: Icons.more_time_rounded,
                  label: "Tiempo de espera",
                )
              : const SizedBox(),
          widget.waitingTimeExtra != null
              ? LabelExtraTripEnd(
                  text: "Recargo espera S/ ${widget.waitingTimeExtra}")
              : const SizedBox(),
        ],
      ),
    );
  }
}
