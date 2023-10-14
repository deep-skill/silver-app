import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/driver/infraestructure/models/trips_summary_driver_response.dart';

class TripsSummaryDriverView extends StatelessWidget {
  const TripsSummaryDriverView({
    super.key,
    required this.size,
    required this.tripsSummary,
  });

  final Size size;
  final AsyncValue<TripsSummaryDriverResponse?> tripsSummary;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color(0xff03132a),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        height: size.height * .1,
        width: size.width * .9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tripsSummary.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
                  data: (tripsSummary) {
                    return tripsSummary != null
                    ? Text('${tripsSummary.trips}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ))
                        : const CircularProgressIndicator();
                  },
                ),
                const Text('Viajes',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ))
              ],
            ),
            const VerticalDivider(
              thickness: 4,
              indent: 15,
              endIndent: 15,
              color: Colors.white,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tripsSummary.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (err, stack) => Text('Error: $err'),
                    data: (tripsSummary) {
                      return tripsSummary!= null
                      ? Text('S/ ${tripsSummary.revenue.toDouble()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ))
                          : const CircularProgressIndicator();
                    }),
                const Text('Ganancia',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ))
              ],
            ),
          ],
        ));
  }
}
