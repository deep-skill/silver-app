import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_end_detail.dart';

class BoxTollsTrip extends StatelessWidget {
  final IconData? icon;
  final String label;
  final List<Toll> tolls;

  const BoxTollsTrip({
    super.key,
    this.icon,
    required this.label,
    required this.tolls,
  });

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Row(
            children: [
              icon != null
                  ? Icon(
                      icon,
                    )
                  : const Text(''),
              const SizedBox(width: 8.0),
              Column(
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
                  )
                ],
              ),
            ],
          )
        : Row(
            children: [
              icon != null
                  ? Icon(
                      icon,
                    )
                  : const Text(''),
              const SizedBox(width: 8.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * .35,
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
                    )
                  ],
                ),
              ),
            ],
          );
  }
}
