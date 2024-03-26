import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';

import '../../../../admin/presentation/widgets/admin_end_trip/title_additional_information.dart';
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
  void putStopStatusDriver(
      BuildContext context, int stopId, String credentials) async {
    try {
      await dio(credentials)
          .put('stops/driver/$stopId', data: {"arrived": true});
      widget.reload();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map),
          Text("Ver mapa"),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "¿Qué direccion deseas visualizar en el mapa?",
            style: TextStyle(
              fontFamily: "Montserrat-Regular",
            ),
          ),
        ],
      ),
      actions: <Widget>[
        widget.stops.isNotEmpty
            ? const TitleAdditionalInformation(
                icon: Icons.add_location_alt_outlined,
                label: "Paradas",
              )
            : const SizedBox(),
        Column(
          children: [
            ...widget.stops.asMap().entries.map((e) {
              final stop = e.value;
              return TextButton(
                onPressed: () => {
                  putStopStatusDriver(context, stop.id, widget.credentials),
                  showBubble(context, stop.lat.toString(), stop.lon.toString()),
                  context.pop()
                },
                child: Text(
                  '- ${stop.location}',
                  style: TextStyle(
                    color: stop.arrived == true ? Colors.red : Colors.black,
                    fontFamily: "Montserrat-Regular",
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              );
            }).toList(),
            const TitleAdditionalInformation(
              icon: Icons.trip_origin,
              label: "Destino final",
            ),
            TextButton(
              onPressed: () => {
                showBubble(
                  context,
                  widget.endAddressLat.toString(),
                  widget.endAddressLon.toString(),
                )
              },
              child: Text(
                '- ${widget.endAddress}',
                style: const TextStyle(
                  fontFamily: "Montserrat-Regular",
                ),
                maxLines: 2,
              ),
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
