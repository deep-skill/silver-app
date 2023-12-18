import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_list.dart';
import 'package:silverapp/roles/admin/presentation/providers/search_trip_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/trip_list_provider.dart';
import 'package:silverapp/roles/admin/presentation/delegates/search_trip_list_delegate.dart';
import 'package:silverapp/roles/admin/presentation/widgets/trip_list.dart';

class TripsListScreen extends StatelessWidget {
  const TripsListScreen({super.key});
  static const name = 'trips';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF2F3F7),
        title: const Text('Historial de viajes'),
        scrolledUnderElevation: 0,
      ),
      body: const TripListView(),
      backgroundColor: const Color(0xffF2F3F7),
    );
  }
}

class TripListView extends ConsumerStatefulWidget {
  const TripListView({super.key});

  @override
  TripListViewState createState() => TripListViewState();
}

class TripListViewState extends ConsumerState<TripListView> {
  @override
  void initState() {
    super.initState();
    if (ref.read(tripsListProvider.notifier).currentPage == 0) {
      ref.read(tripsListProvider.notifier).loadNextPage();
    }
  }

  void sendEventAdminSearchTripsList(
      String querySearched, int amountTripsReturned) {
    FirebaseAnalytics.instance.logEvent(
        name: 'admin_search_trips_list',
        parameters: <String, dynamic>{
          'query_searched': querySearched,
          'amount_reserves_returned': amountTripsReturned
        });
  }

  @override
  Widget build(BuildContext context) {
    final trips = ref.watch(tripsListProvider);
    final size = MediaQuery.of(context).size;

    return kIsWeb
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 220),
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(tripsListProvider.notifier).reloadData(),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      final searchedTrips = ref.read(searchedTripsProvider);
                      final searchQuery = ref.read(searchTripsProvider);

                      showSearch<TripList?>(
                              query: searchQuery,
                              context: context,
                              delegate: SearchTripDelegate(
                                  initialTrips: searchedTrips,
                                  searchTrips: ref
                                      .read(searchedTripsProvider.notifier)
                                      .searchTripsByQuery))
                          .then((trip) {});

                      sendEventAdminSearchTripsList(
                          searchQuery, searchedTrips.length);
                    },
                    child: SizedBox(
                        height: size.height * .07,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  'Búsqueda de viajes',
                                  style: TextStyle(
                                      color: Color(0xFF636D77),
                                      fontSize: 15,
                                      fontFamily: 'Raleway-Semi-Bold'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color(0xff031329),
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
                  Container(
                    width: size.width * .8,
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        const Text('Actualizar',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff364356),
                              fontWeight: FontWeight.bold,
                            )),
                        IconButton(
                          icon: const Icon(Icons.refresh_outlined),
                          onPressed: () {
                            ref.read(tripsListProvider.notifier).reloadData();
                          },
                        ),
                      ],
                    ),
                  ),
                  TripsList(
                    trips: trips,
                    loadNextPage: () {
                      ref.read(tripsListProvider.notifier).loadNextPage();
                    },
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(tripsListProvider.notifier).reloadData(),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      final searchedTrips = ref.read(searchedTripsProvider);
                      final searchQuery = ref.read(searchTripsProvider);

                      showSearch<TripList?>(
                              query: searchQuery,
                              context: context,
                              delegate: SearchTripDelegate(
                                  initialTrips: searchedTrips,
                                  searchTrips: ref
                                      .read(searchedTripsProvider.notifier)
                                      .searchTripsByQuery))
                          .then((trip) {});
                      sendEventAdminSearchTripsList(
                          searchQuery, searchedTrips.length);
                    },
                    child: SizedBox(
                        height: size.height * .07,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  'Búsqueda de viajes',
                                  style: TextStyle(
                                      color: Color(0xFF636D77),
                                      fontSize: 15,
                                      fontFamily: 'Raleway-Semi-Bold'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color(0xff031329),
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
                  TripsList(
                    trips: trips,
                    loadNextPage: () {
                      ref.read(tripsListProvider.notifier).loadNextPage();
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
