import 'package:flutter/material.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_end_detail.dart';
import 'package:silverapp/roles/admin/presentation/widgets/admin_end_trip/trip_label_stop.dart';
import 'package:silverapp/roles/admin/presentation/widgets/box_reserve_detail.dart';

class TripAddressInfoWidget extends StatelessWidget {
  final String startAddress;
  final String endAddress;
  final List<Stop> stops;

  const TripAddressInfoWidget({
    super.key,
    required this.startAddress,
    required this.endAddress,
    required this.stops,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          BoxReserveDetail(
            icon: Icons.location_on_outlined,
            label: "Punto de origen",
            text: startAddress,
          ),
          Row(
            children: [
              Container(
                width: 11.0,
              ),
              Container(
                width: 2.0,
                height: 30.0 * (stops.length + 1),
                color: Colors.black,
                padding: const EdgeInsets.all(2.0),
              ),
              const SizedBox(
                width: 5,
              ),
              stops.isNotEmpty
                  ? Column(
                      children: [
                        const Text(
                          'Paradas:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Color(0xFF23A5CD),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: stops
                              .map((stop) => TripLabelStop(text: stop.location))
                              .toList(),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
          BoxReserveDetail(
            icon: Icons.trip_origin,
            label: "Punto de destino",
            text: endAddress,
          ),
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
