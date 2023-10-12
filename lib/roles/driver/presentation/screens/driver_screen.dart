import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_list_home_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/trip_summary_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/reserve_list_home.dart';
import 'package:silverapp/roles/admin/presentation/widgets/side_menu.dart';
import 'package:silverapp/roles/admin/presentation/widgets/trips_summary_view.dart';
import 'package:silverapp/roles/driver/infraestructure/models/driver_info_response.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_info_provider.dart';
import 'package:silverapp/roles/driver/presentation/providers/trips_summary_driver_provider.dart';
import 'package:silverapp/roles/driver/presentation/widgets/custom_driver_name.dart';
import 'package:silverapp/roles/driver/presentation/widgets/trips_summary_driver_view.dart';

class DriverScreen extends ConsumerWidget {
  static const name = 'admin';
  DriverScreen({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

//    AuthState? authState = ref.watch(authProvider);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      drawer: SideMenu(
        scaffoldKey: scaffoldKey,
      ),
      body: const HomeView(),

    );
  }
}

class HomeView extends ConsumerStatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    if (ref.read(reservesHomeProvider.notifier).currentPage == 0) ref.read(reservesHomeProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Deciembre'
    ];
    Credentials? credential = ref.watch(authProvider).credentials;
    final driverInfo = ref.watch(driverInfoProvider(credential?.user.email));
    final date = DateTime.now().month - 1;
    final tripsSummaryDriver = ref.watch(tripsSummaryDriverProvider(8));

    final tripsSummary = ref.watch(tripsSummaryProvider);
    
    final reserves = ref.watch(reservesHomeProvider);
    return RefreshIndicator(
      onRefresh: () {
       ref.invalidate(tripsSummaryProvider);
       return ref.read(reservesHomeProvider.notifier).reloadData();
      },
      child: Padding(
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
                    )),
                    SizedBox(
                      width: size.width * .04,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('¡Hola!',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              )),
                          CustomDriverName(driverInfo: driverInfo),
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
                        fontSize: 21, fontWeight: FontWeight.bold))),
            SizedBox(height: size.height * .01),

            TripsSummaryDriverView(size: size, tripsSummary: tripsSummaryDriver),
            TripsSummaryView(size: size, tripsSummary: tripsSummary),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerLeft,
              child: const Text('Reservas por asignar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            ReservesListHome(
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