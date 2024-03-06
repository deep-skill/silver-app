import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_reserve_list.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_list.dart';
import 'package:silverapp/roles/driver/presentation/delegates/search_driver_reserve_list_delegate.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_reserve_list_provider.dart';
import 'package:silverapp/roles/driver/presentation/providers/search_driver_reserve_provider.dart';

class DriverReserveListScreen extends StatelessWidget {
  const DriverReserveListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF2F3F7),
        title: const Text('Lista de reservas'),
        scrolledUnderElevation: 0,
      ),
      body: const DriverReserveListView(),
      backgroundColor: const Color(0xffF2F3F7),
    );
  }
}

class DriverReserveListView extends ConsumerStatefulWidget {
  const DriverReserveListView({super.key});

  @override
  DriverReserveListViewState createState() => DriverReserveListViewState();
}

class DriverReserveListViewState extends ConsumerState<DriverReserveListView> {
  @override
  void initState() {
    super.initState();
      ref.read(driverReservesListProvider.notifier).reloadData();
  }

  @override
  Widget build(BuildContext context) {
    final reserves = ref.watch(driverReservesListProvider);
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: RefreshIndicator(
        onRefresh: () =>
            ref.read(driverReservesListProvider.notifier).reloadData(),
        child: Column(
          children: [
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                final searchedReserves =
                    ref.read(searchedDriverReservesProvider);
                final searchQuery = ref.read(searchDriverReservesProvider);

                showSearch<DriverReserveList?>(
                        query: searchQuery,
                        context: context,
                        delegate: SearchDriverReserveDelegate(
                            initialReserves: searchedReserves,
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
            ),
            const SizedBox(height: 15),
            DriverReservesList(
              reserves: reserves,
              loadNextPage: () {
                ref.read(driverReservesListProvider.notifier).loadNextPage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
