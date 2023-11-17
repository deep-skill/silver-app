import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_reserve_detail.dart';

class AddressInfoWidget extends StatelessWidget {
  final String startAddress;
  final String endAddress;

  const AddressInfoWidget({
    required this.startAddress,
    required this.endAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BoxReserveDetail(
          icon: Icons.location_on_outlined,
          label: "Punto de origen",
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
              height: 29.0,
              color: Colors.black,
              padding: const EdgeInsets.all(2.0),
            ),
          ],
        ),
        BoxReserveDetail(
          icon: Icons.trip_origin,
          label: "Punto de destino",
          text: endAddress,
          row: false,
        ),
      ],
    );
  }
}
