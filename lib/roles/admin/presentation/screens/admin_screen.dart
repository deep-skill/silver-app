import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/models/trip_summary_response.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_list_home_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/trip_summary_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/reserve_list_home.dart';
import 'package:silverapp/roles/admin/presentation/widgets/side_menu.dart';
import 'package:silverapp/roles/admin/presentation/widgets/trips_summary_view.dart';

class AdminScreen extends ConsumerWidget {
  static const name = 'admin';
  AdminScreen({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
//    Credentials? credentials = ref.watch(authProvider).credentials;
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
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xff031329),
        onPressed: () {
          context.push('/admin/reserves/create');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
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
    ref.read(reservesHomeProvider.notifier).loadNextPage();
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
    final reserves = ref.watch(reservesHomeProvider);
    final date = DateTime.now().month - 1;
    AsyncValue<TripsSummaryResponse> tripsSummary =
        ref.watch(tripsSummaryProvider);
    return Padding(
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
                  const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('¡Hola!',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                        Text('Silver Express',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
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
    );
  }
}
