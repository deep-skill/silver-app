import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';

class DriverTripLabelObservation extends StatelessWidget {
  final IconData? icon;
  final String label;
  final List<Observations> observations;

  const DriverTripLabelObservation({
    super.key,
    this.icon,
    required this.label,
    required this.observations,
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
          width: MediaQuery.of(context).size.width * .8,
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
                children: observations
                    .map((e) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF23A5CD)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.all(4.0),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            e.observation,
                            maxLines: 5,
                            style: const TextStyle(
                              fontFamily: 'Montserrat-Medium',
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                            ),
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
