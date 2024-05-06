// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/google_maps/google_maps_screen.dart';
import 'package:silverapp/google_maps/location_data.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_end_detail.dart';
import 'package:silverapp/roles/admin/presentation/widgets/admin_end_trip/alertDilog/alert_default.dart';
import 'package:silverapp/roles/admin/presentation/widgets/admin_end_trip/alertDilog/alert_observation.dart';
import 'package:silverapp/roles/admin/presentation/widgets/admin_end_trip/alertDilog/alert_parkin_lot.dart';
import 'package:silverapp/roles/admin/presentation/widgets/admin_end_trip/alertDilog/alert_tolls.dart';
import 'package:silverapp/roles/admin/presentation/widgets/admin_end_trip/label_trip_extra.dart';
import 'package:silverapp/roles/admin/presentation/widgets/admin_end_trip/label_trip_extra_end.dart';
import 'package:silverapp/roles/admin/presentation/widgets/admin_end_trip/title_additional_information.dart';
import 'package:silverapp/roles/admin/presentation/widgets/box_reserve_detail.dart';

class AdminAdditionalInformation extends StatefulWidget {
  final String credentials;
  final int tripId;
  final String startAddress;
  final String? endAddress;
  final VoidCallback reload;
  final List<Stop> stops;
  final List<Observations> observations;
  final List<Parking> parkings;
  final List<Toll> tolls;
  final double? waitingTimeExtra;

  const AdminAdditionalInformation(
      {Key? key,
      required this.credentials,
      required this.tripId,
      required this.startAddress,
      required this.endAddress,
      required this.reload,
      required this.stops,
      required this.observations,
      required this.parkings,
      required this.tolls,
      required this.waitingTimeExtra})
      : super(key: key);

  @override
  State<AdminAdditionalInformation> createState() =>
      _AdminAdditionalInformationState();
}

class _AdminAdditionalInformationState
    extends State<AdminAdditionalInformation> {
  String selectedOption = 'Selecciona ítem';

  late List<Stop> stops;
  late List<Observations> observations;
  late List<Parking> parkings;
  late List<Toll> tolls;
  bool boolValue = false;

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
      context.go("/admin/error-server/${e.toString()}");
    }
  }

  void addStops(String address, double lat, double lon) async {
    try {
      await dio(widget.credentials).post('stops', data: {
        "location": address,
        "lat": lat,
        "lon": lon,
        "tripId": widget.tripId
      });
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/admin/error-server/${e.response!.data['message'].toString()}- uuid error: ${e.response!.data['error'].toString()}");
      widget.reload();
    }
  }

  void removeStop(int stopId) async {
    try {
      await dio(widget.credentials).delete(
        'stops/$stopId',
      );
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/admin/error-server/${e.response!.data['message'].toString()}- uuid error: ${e.response!.data['error'].toString()}");
      widget.reload();
    }
  }

  void addObservations(String observation) async {
    try {
      await dio(widget.credentials).post('observations',
          data: {"observation": observation, "tripId": widget.tripId});
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/admin/error-server/${e.response!.data['message'].toString()}- uuid error: ${e.response!.data['error'].toString()}");
      widget.reload();
    }
  }

  void remObservations(int observationId) async {
    try {
      await dio(widget.credentials).delete(
        'observations/$observationId',
      );
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/admin/error-server/${e.response!.data['message'].toString()} - uuid error: ${e.response!.data['error'].toString()}");
      widget.reload();
    }
  }

  void addParking(String parking, double amount) async {
    try {
      await dio(widget.credentials).post('parkings',
          data: {"name": parking, "tripId": widget.tripId, "amount": amount});
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/admin/error-server/${e.response!.data['message'].toString()}- uuid error: ${e.response!.data['error'].toString()}");
      widget.reload();
    }
  }

  void remParking(int parkingId) async {
    try {
      await dio(widget.credentials).delete('parkings/$parkingId');
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/admin/error-server/${e.response!.data['message'].toString()}- uuid error: ${e.response!.data['error'].toString()}");
      widget.reload();
    }
  }

  void addTools(String name, double amount, double lat, double lon) async {
    try {
      await dio(widget.credentials).post('tolls', data: {
        "tripId": widget.tripId,
        "name": name,
        "amount": amount,
        "lat": lat,
        "lon": lon
      });
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/admin/error-server/${e.response!.data['message'].toString()}- uuid error: ${e.response!.data['error'].toString()}");
      widget.reload();
    }
  }

  void remTolls(int tollId) async {
    try {
      await dio(widget.credentials).delete('tolls/$tollId');
      widget.reload();
    } on DioException catch (e) {
      context.go(
          "/admin/error-server/${e.response!.data['message'].toString()}- uuid error: ${e.response!.data['error'].toString()}");
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
                addToll: addTools,
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
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                BoxReserveDetail(
                  icon: Icons.location_on_outlined,
                  label: "Punto de origen",
                  text: widget.startAddress,
                ),
                const SizedBox(
                  height: 5.0,
                ),
                widget.endAddress != null
                    ? BoxReserveDetail(
                        icon: Icons.trip_origin,
                        label: "Punto de destino",
                        text: widget.endAddress,
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
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
          const TitleAdditionalInformation(
            icon: Icons.add_location_alt_outlined,
            label: "Parada",
          ),
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
          const SizedBox(height: 8),
          const TitleAdditionalInformation(
            icon: Icons.paid_outlined,
            label: "Peaje",
          ),
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
          const SizedBox(height: 8),
          const TitleAdditionalInformation(
            icon: Icons.local_parking,
            label: "Estacionamiento",
          ),
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
          const SizedBox(height: 8),
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
          TextButton(
              onPressed: () {
                setState(() => boolValue = !boolValue);
              },
              child: const Text(
                "Modificar extras",
                style: TextStyle(color: Color(0xff03132A), fontSize: 15),
              )),
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
