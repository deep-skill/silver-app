import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';
import 'package:silverapp/roles/admin/presentation/delegates/search_reserve_list_delegate.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_list_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/search_reserve_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/reserve_list.dart';

class ReserveListScreen extends StatelessWidget {
  const ReserveListScreen({super.key});
  static const name = 'reserves';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF2F3F7),
        title: const Text('Lista de reservas'),
        scrolledUnderElevation: 0,
      ),
      body: const ReserveListView(),
      backgroundColor: const Color(0xffF2F3F7),
    );
  }
}

class ReserveListView extends ConsumerStatefulWidget {
  const ReserveListView({super.key});

  @override
  ReserveListViewState createState() => ReserveListViewState();
}

class ReserveListViewState extends ConsumerState<ReserveListView> {
  @override
  void initState() {
    super.initState();
    ref.read(reservesListProvider.notifier).reloadData();
  }

  void sendEventAdminSearchReservesList(
      String querySearched, int amountReservesReturned) {
    FirebaseAnalytics.instance.logEvent(
        name: 'admin_search_reserves_list',
        parameters: <String, dynamic>{
          'query_searched': querySearched,
          'amount_reserves_returned': amountReservesReturned
        });
  }

  @override
  Widget build(BuildContext context) {
    final reserves = ref.watch(reservesListProvider);
    final size = MediaQuery.of(context).size;
    return kIsWeb
        ? Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width >= 1200 ? 220 : size.width * .07),
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(reservesListProvider.notifier).reloadData(),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      final searchedReserves =
                          ref.read(searchedReservesProvider);
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
                      sendEventAdminSearchReservesList(
                          searchQuery, searchedReserves.length);
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
                                    fontFamily: 'Raleway-Semi-Bold',
                                    color: Color(0xFF636d77),
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
                            ref
                                .read(reservesListProvider.notifier)
                                .reloadData();
                          },
                        ),
                      ],
                    ),
                  ),
                  ReservesList(
                    reserves: reserves,
                    loadNextPage: () {
                      ref.read(reservesListProvider.notifier).loadNextPage();
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
                  ref.read(reservesListProvider.notifier).reloadData(),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      final searchedReserves =
                          ref.read(searchedReservesProvider);
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
                      sendEventAdminSearchReservesList(
                          searchQuery, searchedReserves.length);
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
