import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_reserve_detail.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_trip_ended_widgets/driver_trip_label_stop.dart';

class DriverTripAddressInfoWidget extends StatelessWidget {
  final String startAddress;
  final String? endAddress;
  final List<Stop> stops;

  const DriverTripAddressInfoWidget({
    super.key,
    required this.startAddress,
    required this.endAddress,
    required this.stops,
  });

  @override
  Widget build(BuildContext context) {
    print('stops is empty ${stops.isEmpty}');

    return Column(
      children: [
        BoxReserveDetail(
          icon: Icons.location_on_outlined,
          label: "Punto de recojo",
          text: startAddress,
          row: false,
        ),
        Row(
          children: [
            Container(
              width: 11.0,
            ),
            Container(
              width: 2.0,
              height: 25.0 * (stops.length + 1),
              color: Colors.black,
              padding: const EdgeInsets.all(2.0),
            ),
            const SizedBox(
              width: 5,
            ),
            stops.isEmpty == false
                ? Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.0),
                        child: Text(
                          'Paradas:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Color(0xFF23A5CD),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: stops
                            .map((stop) =>
                                DriverTripLabelStop(text: stop.location))
                            .toList(),
                      ),
                    ],
                  )
                : SizedBox()
          ],
        ),
        endAddress != null
            ? BoxReserveDetail(
                icon: Icons.trip_origin,
                label: "Punto de destino",
                text: endAddress!,
                row: false)
            : const SizedBox()
      ],
    );
  }
}
