import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_list.dart';
import 'package:silverapp/roles/driver/presentation/delegates/search_driver_trip_list_delegate.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_trip_list_provider.dart';
import 'package:silverapp/roles/driver/presentation/providers/search_driver_trip_provider.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_trips_list/driver_trips_list.dart';

class DriverTripListScreen extends StatelessWidget {
  const DriverTripListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF2F3F7),
        title: const Text('Historial de viajes'),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: const DriverTripListView(),
      backgroundColor: const Color(0xffF2F3F7),
    );
  }
}

class DriverTripListView extends ConsumerStatefulWidget {
  const DriverTripListView({super.key});

  @override
  DriverReserveListViewState createState() => DriverReserveListViewState();
}

class DriverReserveListViewState extends ConsumerState<DriverTripListView> {
  @override
  void initState() {
    super.initState();
    if (ref.read(driverTripsListProvider.notifier).currentPage == 0) {
      ref.read(driverTripsListProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final trips = ref.watch(driverTripsListProvider);
    final size = MediaQuery.of(context).size;
    void sendEventDriverSearchTripsList(
        String querySearched, int amountTripsReturned) {
      FirebaseAnalytics.instance.logEvent(
          name: 'driver_search_trips_list',
          parameters: <String, dynamic>{
            'query_searched': querySearched,
            'amount_trips_returned': amountTripsReturned
          });

      print(
          'driver search reserves list $querySearched  amount: $amountTripsReturned');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: RefreshIndicator(
        onRefresh: () =>
            ref.read(driverTripsListProvider.notifier).reloadData(),
        child: Column(
          children: [
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                final searchedTrips = ref.read(searchedDriverTripsProvider);
                final searchQuery = ref.read(searchDriverTripsProvider);

                showSearch<DriverTripList?>(
                        query: searchQuery,
                        context: context,
                        delegate: SearchDriverTripDelegate(
                            initialTrips: searchedTrips,
                            searchTrips: ref
                                .read(searchedDriverTripsProvider.notifier)
                                .searchTripsByQuery))
                    .then((reserve) {});
                sendEventDriverSearchTripsList(
                    searchQuery, searchedTrips.length);
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
                              color: Color(0xFF636D77),
                              fontFamily: 'Montserrat-Regular',
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
            const SizedBox(height: 15),
            DriverTripsList(
              trips: trips,
              loadNextPage: () {
                ref.read(driverTripsListProvider.notifier).loadNextPage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
