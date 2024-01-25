import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/admin/infraestructure/models/trip_summary_response.dart';

class TripsSummaryViewWeb extends StatelessWidget {
  const TripsSummaryViewWeb({
    super.key,
    required this.size,
    required this.tripsSummary,
    required this.months,
    required this.date,
  });
  final Size size;
  final AsyncValue<TripsSummaryResponse> tripsSummary;
  final List<String> months;
  final int date;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        height: size.height * .18,
        width: size.width * .8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text('Resumen del mes',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        // fontWeight: FontWeight.w700,
                      )),
                ),
                SizedBox(
                    child: Text(months[date],
                        style: const TextStyle(
                            color: Color(0xff23a5cd), fontSize: 24))),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Número de viajes',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                tripsSummary.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
                  data: (tripsSummary) {
                    return Container(
                      margin: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xff031329),
                          borderRadius: BorderRadius.circular(7)),
                      width: size.width * .10,
                      height: size.height * 0.07,
                      child: Text('${tripsSummary.trips}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24.31,
                              fontFamily: 'Montserrat-Bold')),
                    );
                  },
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ingresos',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                tripsSummary.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (err, stack) => Text('Error: $err'),
                    data: (tripsSummary) {
                      return Container(
                        margin: const EdgeInsets.all(12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0xff031329),
                            borderRadius: BorderRadius.circular(7)),
                        width: size.width * .10,
                        height: size.height * 0.07,
                        child: Text('S/ ${tripsSummary.income.toInt()}',
                            style: const TextStyle(
                                fontFamily: 'Montserrat-Bold',
                                color: Colors.white,
                                fontSize: 24.31)),
                      );
                    }),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ganancia',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                tripsSummary.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
                  data: (tripsSummary) {
                    return Container(
                      margin: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xff031329),
                          borderRadius: BorderRadius.circular(7)),
                      width: size.width * .10,
                      height: size.height * 0.07,
                      child: Text('S/ ${tripsSummary.revenue.toInt()}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat-Bold',
                              fontSize: 24.31)),
                    );
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
