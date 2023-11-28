import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';

class DriverTripLabelToll extends StatelessWidget {
  final IconData? icon;
  final String label;
  final List<Toll> tolls;

  const DriverTripLabelToll({
    super.key,
    this.icon,
    required this.label,
    required this.tolls,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Row(
      children: [
        icon != null
            ? Icon(
                icon,
              )
            : const Text(''),
        const SizedBox(width: 8.0),
        SizedBox(
          width: MediaQuery.of(context).size.width * .6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF23A5CD),
                  fontFamily: 'Montserrat-Medium',
                  fontSize: 12,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: tolls
                    .map((e) => Text(
                          "${e.name} - S/ ${e.amount}",
                          maxLines: 2,
                          style: const TextStyle(
                            fontFamily: 'Montserrat-Medium',
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(
                height: size.width * 0.03,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
