import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_list.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_trip_list_provider.dart';
import 'package:silverapp/roles/driver/presentation/providers/search_driver_trip_provider.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_trips_list/driver_trips_list.dart';

class DriverTripListScreen extends StatelessWidget {
  const DriverTripListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Historial de viajes'),
          centerTitle: true,
          scrolledUnderElevation: 0,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            padding: const EdgeInsets.all(3),
            child: const DriverTripListView()));
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
    //final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: RefreshIndicator(
        onRefresh: () =>
            ref.read(driverTripsListProvider.notifier).reloadData(),
        child: Column(
          children: [
            const SizedBox(height: 15),
            /* GestureDetector(
              onTap: () {
                final searchedTrips = ref.read(searchedDriverTripsProvider);
                final searchQuery = ref.read(searchDriverTripsProvider);

                showSearch<DriverTripList?>(
                        query: searchQuery,
                        context: context,
                        delegate: SearchDriverReserveDelegate(
                            initialReserves: searchedTrips,
                            searchReserves: ref
                                .read(searchedDriverReservesProvider.notifier)
                                .searchReservesByQuery))
                    .then((reserve) {});
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
            ), */
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
