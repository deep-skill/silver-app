import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_home.dart';
import 'package:silverapp/roles/admin/infraestructure/models/trip_summary_response.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_list_home_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/trip_summary_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/reserve_list_home_web.dart';
import 'package:silverapp/roles/admin/presentation/widgets/trips_summary_view_web.dart';

class AdminHomeWebView extends StatelessWidget {
  const AdminHomeWebView({
    super.key,
    required this.ref,
    required this.size,
    required this.months,
    required this.date,
    required this.tripsSummary,
    required this.reserves,
  });

  final WidgetRef ref;
  final Size size;
  final List<String> months;
  final int date;
  final AsyncValue<TripsSummaryResponse> tripsSummary;
  final List<ReserveHome> reserves;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        ref.invalidate(tripsSummaryProvider);
        return ref.read(reservesHomeProvider.notifier).reloadData();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 250),
        child: Column(
          children: [
            // SizedBox(
            // width: size.width * .9,
            // child: Text(months[date],
            // textAlign: TextAlign.start,
            // style: const TextStyle(
            // fontSize: 21, fontWeight: FontWeight.bold))),
            TripsSummaryViewWeb(
              size: size,
              tripsSummary: tripsSummary,
              months: months,
              date: date,
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: size.width * .8,
              padding: const EdgeInsets.all(15),
              alignment: Alignment.centerLeft,
              child: const Text('Reservas por asignar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            ReservesListHomeWeb(
              reserves: reserves,
              loadNextPage: () {
                ref.read(reservesHomeProvider.notifier).loadNextPage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
