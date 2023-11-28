import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_reserve_detail.dart';

class AddressInfoWidget extends StatelessWidget {
  final String startAddress;
  final String? endAddress;

  const AddressInfoWidget({
    super.key,
    required this.startAddress,
    this.endAddress,
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
        if (endAddress != null)
          Column(
            children: [
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
                text: endAddress!,
                row: false,
              ),
            ],
          ),
      ],
    );
  }
}
