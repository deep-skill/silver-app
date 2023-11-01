import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_info_provider.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_nearest_reserve_provider.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_reserve_list_home_provider.dart';
import 'package:silverapp/roles/driver/presentation/providers/trips_summary_driver_provider.dart';
import 'package:silverapp/roles/driver/presentation/widgets/custom_driver_name.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_reserve_list_home.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_side_menu.dart';
import 'package:silverapp/roles/driver/presentation/widgets/trips_summary_driver_view.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_custom_slide.dart';

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
      drawer: DriverSideMenu(
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
    if (ref.read(driverReservesHomeProvider.notifier).currentPage == 0) ref.read(driverReservesHomeProvider.notifier).loadNextPage();
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
    final driverInfo = ref.watch(driverInfoProvider);
    final tripsSummaryDriver = ref.watch(tripsSummaryDriverProvider);
    final nearestReserve = ref.watch(nearestReserveProvider);
    final date = DateTime.now();
    final reserves = ref.watch(driverReservesHomeProvider);
    Future createTrip(id) async {
        await dio.post('/trips', data: {
          "reserve_id": id,
          "on_way_driver":
              date.toIso8601String()
        });
    }

    return RefreshIndicator(
      onRefresh: () {
        ref.invalidate(driverInfoProvider);
        return ref.read(driverReservesHomeProvider.notifier).reloadData();
      },
      child: Stack(
        children: <Widget> [ListView(), Padding(
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
                  child: Text(months[date.month - 1],
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 21, fontWeight: FontWeight.bold))),
              SizedBox(height: size.height * .01),
              TripsSummaryDriverView(
                  size: size, tripsSummary: tripsSummaryDriver),
              const SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: nearestReserve.when(
                  loading: () => const Text('Cargando...',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  error: (err, stack) => Text('Error: $err'),
                  data: (nearestReserve) {
                    return nearestReserve?.tripId != null
                        ? const Text('Viaje en curso',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ))
                        : const Text('Reserva mas próxima',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ));
                  },
                ),
              ),
              nearestReserve.when(
                loading: () => SizedBox(
                    height: size.height * .15,
                    child: const Center(child: CircularProgressIndicator())),
                error: (err, stack) => Text('Error: $err'),
                data: (nearestReserve) {
                  return nearestReserve != null
                      ? Column(
                          children: [
                            DriverCustomSlide(reserve: nearestReserve),
                            Center(
                              child: TextButton(
                                onPressed: () async {
                                  if (nearestReserve.startTime
                                              .difference(date)
                                              .inHours <
                                          2 &&
                                      nearestReserve.tripId == null) {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              '¿Estás seguro de que vas en camino?',
                                              textAlign: TextAlign.center),
                                          content: const Text(
                                            'Marca esta opción solo si ya vas a aproximarte hasta el punto de origen.',
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.white),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        const Color(0xff23A5CD)),
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                  ),
                                                ),
                                              ),
                                              child: const Text('Confirmar'),
                                              onPressed: () {
                                                createTrip(nearestReserve.id);
                                                ref.invalidate(
                                                    driverInfoProvider);
                                                context.pop();
                                              },
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge,
                                              ),
                                              child: const Text('Cancelar'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                                  fixedSize: MaterialStateProperty.all(
                                      Size(size.width * .8, size.height * .06)),
                                  backgroundColor: nearestReserve.startTime
                                                  .difference(date)
                                                  .inHours <
                                              2 &&
                                          nearestReserve.tripId == null
                                      ? MaterialStateProperty.all(
                                          const Color(0xFF23A5CD))
                                      : MaterialStateProperty.all(
                                          const Color(0xFF9E9E9E)),
                                ),
                                child: const Text('Voy en camino',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ],
                        )
                      : const Center(child: Text('No hay reserva próxima'));
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text('Reservas del día',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              DriverReservesListHome(
                reserves: reserves,
                loadNextPage: () {
                  ref.read(driverReservesHomeProvider.notifier).loadNextPage();
                },
              ),
            ],
          ),
        )]
      ),
    );
  }
}
