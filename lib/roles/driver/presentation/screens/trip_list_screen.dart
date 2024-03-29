import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';
import 'package:silverapp/roles/admin/presentation/delegates/search_reserve_list_delegate.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_list_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/search_reserve_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/reserve_list.dart';

class DriverTripListScreen extends StatelessWidget {
  const DriverTripListScreen({super.key});
  static const name = 'reserves';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de reservas'),
          scrolledUnderElevation: 0,
        ),
        body: const DriverTripListView());
  }
}

class DriverTripListView extends ConsumerStatefulWidget {
  const DriverTripListView({super.key});

  @override
  DriverTripListViewState createState() => DriverTripListViewState();
}

class DriverTripListViewState extends ConsumerState<DriverTripListView> {
  @override
  void initState() {
    super.initState();
    ref.read(reservesListProvider.notifier).reloadData();
  }

  @override
  Widget build(BuildContext context) {
    final reserves = ref.watch(reservesListProvider);
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: RefreshIndicator(
        onRefresh: () => ref.read(reservesListProvider.notifier).reloadData(),
        child: Column(
          children: [
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                final searchedReserves = ref.read(searchedReservesProvider);
                final searchQuery = ref.read(searchReservesProvider);

                showSearch<ReserveList?>(
                        query: searchQuery,
                        context: context,
                        delegate: SearchReserveDelegate(
                            initialReserves: searchedReserves,
                            searchReserves: ref
                                .read(searchedReservesProvider.notifier)
                                .searchReservesByQuery))
                    .then((reserve) {});
              },
              child: SizedBox(
                  height: size.height * .07,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xffF2F3F7),
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
                              color: Colors.grey,
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
            ReservesList(
              reserves: reserves,
              loadNextPage: () {
                ref.read(reservesListProvider.notifier).loadNextPage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
