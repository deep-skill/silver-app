import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/user/models/trip_summary_response.dart';

class TripsSummaryView extends StatelessWidget {
  const TripsSummaryView({
    super.key,
    required this.size,
    required this.tripsSummary,
  });

  final Size size;
  final AsyncValue<TripsSummaryResponse> tripsSummary;

/*  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    final date = DateTime.now().month - 1;
*/
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(months[date],
                Text('Setiembre',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    )),
                Text('Viajes realizados',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    )),
              ],
            ),
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
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ));
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
//}
