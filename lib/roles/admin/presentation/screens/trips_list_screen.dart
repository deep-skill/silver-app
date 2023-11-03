import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_list.dart';
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
        title: const Text('Historial de viajes'),
        scrolledUnderElevation: 0,
      ),
      body: const TripListView(),
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

  @override
  Widget build(BuildContext context) {
    final trips = ref.watch(tripsListProvider);
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: RefreshIndicator(
        onRefresh: () => ref.read(tripsListProvider.notifier).reloadData(),
        child: Column(
          children: [
            const SizedBox(height: 15),
            // GestureDetector(
            //   onTap: () {
            //     final searchedTrips = ref.read(searchedTripsProvider);
            //     final searchQuery = ref.read(searchTripsProvider);

            //     showSearch<TripList?>(
            //             query: searchQuery,
            //             context: context,
            //             delegate: SearchTripDelegate(
            //                 initialTrips: searchedTrips,
            //                 searchTrips: ref
            //                     .read(searchedTripsProvider)
            //                     .searchReservesByQuery))
            //         .then((reserve) {});
            //   },
            //   child: SizedBox(
            //       height: size.height * .07,
            //       child: const DecoratedBox(
            //         decoration: BoxDecoration(
            //           color: Color(0xffF2F3F7),
            //           borderRadius: BorderRadius.all(Radius.circular(12)),
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Padding(
            //               padding: EdgeInsets.only(left: 20),
            //               child: Text(
            //                 'Búsqueda de reservas',
            //                 style: TextStyle(
            //                   color: Colors.grey,
            //                   fontSize: 16,
            //                 ),
            //               ),
            //             ),
            //             Padding(
            //               padding: EdgeInsets.only(right: 20),
            //               child: SizedBox(
            //                 height: 45,
            //                 width: 45,
            //                 child: DecoratedBox(
            //                   decoration: BoxDecoration(
            //                     color: Color(0xff031329),
            //                     borderRadius:
            //                         BorderRadius.all(Radius.circular(12)),
            //                   ),
            //                   child: Icon(
            //                     Icons.search,
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //               ),
            //             )
            //           ],
            //         ),
            //       )),
            // ),
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
