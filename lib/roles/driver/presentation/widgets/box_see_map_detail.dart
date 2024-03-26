import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/helpers/see_map_bubble_helpers.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_see_map.dart';
import '../../infraestructure/entities/driver_trip_state.dart';

class SeeMap extends StatelessWidget {
  final String credentials;
  final VoidCallback reload;
  final DateTime? arrivedDriver;
  final DateTime? startTime;
  final DateTime? endTime;
  final String startAddress;
  final double startAddressLat;
  final double startAddressLon;
  final String? endAddress;
  final double? endAddressLat;
  final double? endAddressLon;
  final List<Stop> stops;

  const SeeMap({
    super.key,
    required this.reload,
    required this.credentials,
    required this.arrivedDriver,
    required this.startTime,
    required this.endTime,
    required this.startAddress,
    required this.startAddressLat,
    required this.startAddressLon,
    required this.stops,
    this.endAddress,
    this.endAddressLat,
    this.endAddressLon,
  });

  @override
  Widget build(BuildContext context) {
    //showBubble(context, endAddressLat.toString(), endAddressLon.toString());

    return SizedBox(
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        ElevatedButton(
            child: const Row(children: [
              Icon(
                Icons.map,
                color: Color(0xFF23A5CD),
              ),
              Text("Ver mapa",
                  style: TextStyle(
                    color: Color(0xFF23A5CD),
                    decoration: TextDecoration.underline,
                    fontFamily: "Montserrat-Bold",
                    fontSize: 16,
                  ))
            ]),
            onPressed: () {
              if (arrivedDriver == null) {
                showBubble(context, startAddressLat.toString(),
                    startAddressLon.toString());
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertSeeMapDriver(
                    stops: stops,
                    reload: reload,
                    credentials: credentials,
                    endAddress: endAddress,
                    endAddressLat: endAddressLat,
                    endAddressLon: endAddressLon,
                  ),
                );
              }
            }),
      ]),
    );
  }
}
