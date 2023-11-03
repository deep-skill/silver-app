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
        height: size.height * .2,
        width: size.width * .7,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 34),
                  child: Text('Resumen del mes',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      )),
                ),
                SizedBox(
                    child: Text(months[date],
                        style: const TextStyle(
                            color: Color(0xff23a5cd),
                            fontSize: 24,
                            fontWeight: FontWeight.bold))),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Número de viajes',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    )),
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
                      width: 140,
                      height: 60,
                      child: Text('${tripsSummary.trips}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24.31,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          )),
                    );
                  },
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ingresos',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    )),
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
                        width: 140,
                        height: 60,
                        child: Text('S/ ${tripsSummary.income.toInt()}',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: 24.31,
                              fontWeight: FontWeight.w700,
                            )),
                      );
                    }),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ganancia',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    )),
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
                      width: 140,
                      height: 60,
                      child: Text('S/ ${tripsSummary.revenue.toInt()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 24.31,
                            fontWeight: FontWeight.w700,
                          )),
                    );
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
