import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_home.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';
import 'package:silverapp/roles/admin/infraestructure/models/trip_summary_response.dart';
import 'package:silverapp/roles/admin/presentation/delegates/search_reserve_list_delegate.dart';
import 'package:silverapp/roles/admin/presentation/providers/lists/reserve_list_home_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/search_reserve_no_driver_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/trip_summary_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/lists/reserve_list_home_app.dart';
import 'package:silverapp/roles/admin/presentation/widgets/trips_summary_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AdminHomeAppView extends StatelessWidget {
  const AdminHomeAppView({
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
    bool isLogged =
        ref.watch(authProvider).credentials?.user.email == null ? false : true;
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () {
        ref.invalidate(tripsSummaryProvider);
        return ref.read(reservesHomeProvider.notifier).reloadData();
      },
      child: Stack(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      SizedBox(
                          child: Image.asset(
                        "assets/images/app_logo.png",
                        width: size.width * .2,
                        color: const Color(0xff03132a),
                      )),
                      SizedBox(
                        width: size.width * .04,
                      ),
                      const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('¡Hola!', style: TextStyle(fontSize: 32)),
                            Text('Silver Express',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Raleway-Semi-Bold')),
                          ])
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height * .01,
              ),
              SizedBox(
                  width: size.width * .9,
                  child: Text(months[date],
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Roboto-Bold',
                          color: Color(0xff364356)))),
              SizedBox(height: size.height * .01),
              TripsSummaryView(
                  size: size, tripsSummary: tripsSummary, isLogged: isLogged),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.centerLeft,
                child: const Text('Reservas por asignar',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff364356),
                    )),
              ),
              GestureDetector(
                onTap: () {
                  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

                  final searchedReserves =
                      ref.read(searchedNoDriverReservesProvider);
                  final searchQuery = ref.read(searchNoDriverReservesProvider);

                  showSearch<ReserveList?>(
                          query: searchQuery,
                          context: context,
                          delegate: SearchReserveDelegate(
                              initialReserves: searchedReserves,
                              searchReserves: ref
                                  .read(
                                      searchedNoDriverReservesProvider.notifier)
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
                                fontFamily: 'Montserrat-Regular',
                                color: Color(0xFF636D77),
                                fontSize: 16,
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
              ReservesListHomeApp(
                reserves: reserves,
                loadNextPage: () {
                  ref.read(reservesHomeProvider.notifier).loadNextPage();
                },
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * .25, child: ListView()),
      ]),
    );
  }
}
