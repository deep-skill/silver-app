import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';

import '../../../helpers/see_map_bubble_helpers.dart';

class AlertSeeMapDriver extends StatefulWidget {
  final String credentials;
  final VoidCallback reload;
  final String? endAddress;
  final double? endAddressLat;
  final double? endAddressLon;
  final List<Stop> stops;
  const AlertSeeMapDriver({
    Key? key,
    required this.reload,
    required this.credentials,
    required this.endAddress,
    required this.endAddressLat,
    required this.endAddressLon,
    required this.stops,
  }) : super(key: key);

  @override
  State<AlertSeeMapDriver> createState() => _AlertSeeMapState();
}

class _AlertSeeMapState extends State<AlertSeeMapDriver> {
  void patchArrivedDriver(
      BuildContext context, int tripId, String credentials) async {
    try {
      await dio(credentials).patch('trips/driver-trip/$tripId',
          data: {"arrivedDriver": DateTime.now().toUtc().toIso8601String()});
      widget.reload();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ver mapa"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Que punto desear ver?"),
        ],
      ),
      actions: <Widget>[
        Column(
          children: [
            ...widget.stops.asMap().entries.map((e) {
              final stop = e.value;
              return TextButton(
                onPressed: () => {
                  showBubble(context, stop.lat.toString(), stop.lon.toString()),
                },
                child: Text('ir a ${stop.location}'),
              );
            }).toList(),
            TextButton(
              onPressed: () => {
                showBubble(
                  context,
                  widget.endAddressLat.toString(),
                  widget.endAddressLon.toString(),
                )
              },
              child: Text('ir a ${widget.endAddress}'),
            ),
          ],
        ),
        Row(children: [
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
        ])
      ],
    );
  }
}
