import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_home.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';
import 'package:silverapp/roles/admin/infraestructure/models/trip_summary_response.dart';
import 'package:silverapp/roles/admin/presentation/delegates/search_reserve_list_delegate.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_list_home_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/search_reserve_no_driver_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/trip_summary_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/lists/reserve_list_home_web.dart';
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
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        children: [
          TripsSummaryViewWeb(
            size: size,
            tripsSummary: tripsSummary,
            months: months,
            date: date,
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            width: size.width * .8,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const Text('Reservas por asignar',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff364356),
                      fontWeight: FontWeight.bold,
                    )),
                IconButton(
                  icon: const Icon(Icons.refresh_outlined),
                  onPressed: () {
                    ref.invalidate(tripsSummaryProvider);
                    ref.read(reservesHomeProvider.notifier).reloadData();
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              final searchedReserves =
                  ref.read(searchedNoDriverReservesProvider);
              final searchQuery = ref.read(searchNoDriverReservesProvider);

              showSearch<ReserveList?>(
                      query: searchQuery,
                      context: context,
                      delegate: SearchReserveDelegate(
                          initialReserves: searchedReserves,
                          searchReserves: ref
                              .read(searchedNoDriverReservesProvider.notifier)
                              .searchReservesByQuery))
                  .then((reserve) {
                analytics.logEvent(
                    name: 'admin_search_home',
                    parameters: <String, dynamic>{
                      'word_searched': searchQuery
                    });
              });
            },
            child: SizedBox(
                width: size.width * 0.8,
                height: size.height * .07,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Búsqueda de reservas',
                          style: TextStyle(
                            fontFamily: 'Raleway-Semi-Bold',
                            color: Color(0xFF636D77),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: SizedBox(
                          height: 45,
                          width: 45,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color(0xff03132A),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
          const SizedBox(height: 15),
          ReservesListHomeWeb(
            size: size,
            reserves: reserves,
            loadNextPage: () {
              ref.read(reservesHomeProvider.notifier).loadNextPage();
            },
          ),
        ],
      ),
    );
  }
}
