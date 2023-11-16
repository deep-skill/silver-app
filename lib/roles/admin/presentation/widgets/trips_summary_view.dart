import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/admin/infraestructure/models/trip_summary_response.dart';

class TripsSummaryView extends StatelessWidget {
  const TripsSummaryView({
    super.key,
    required this.size,
    required this.tripsSummary,
  });

  final Size size;
  final AsyncValue<TripsSummaryResponse> tripsSummary;

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
                    return Text('${tripsSummary.trips}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Montserrat-Bold'));
                  },
                ),
                const Text('Viajes',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat-Semi-Bold',
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
                      return Text('S/ ${tripsSummary.income.toInt()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Montserrat-Bold',
                          ));
                    }),
                const Text('Ingresos',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat-Semi-Bold'))
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
                    return Text('S/ ${tripsSummary.revenue.toInt()}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Montserrat-Bold'));
                  },
                ),
                const Text('Ganancia',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat-Semi-Bold'))
              ],
            ),
          ],
        ));
  }
}
