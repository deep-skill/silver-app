import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/driver/helpers/datatime_rouded_string.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_info_provider.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_nearest_reserve_provider.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_reserve_list_home_provider.dart';
import 'package:silverapp/roles/driver/presentation/providers/trips_summary_driver_provider.dart';
import 'package:silverapp/roles/driver/presentation/screens/driver_web_deny_screen.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_start_trip.dart';
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
    return Scaffold(
      key: scaffoldKey,
      appBar: kIsWeb
          ? null
          : AppBar(
              scrolledUnderElevation: 0,
            ),
      drawer: kIsWeb ? null : DriverSideMenu(scaffoldKey: scaffoldKey),
      body: kIsWeb ? const DriverWebDenyScreen() : const HomeView(),
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
  bool analyticsEventLogged = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!analyticsEventLogged) {
      sendEventDriverHomeOpen();
      analyticsEventLogged = true;
    }
  }

  void sendEventDriverHomeOpen() {
    final credentials = ref.read(authProvider).credentials;
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    final String? userEmail = credentials?.user.email;
    final int hour = DateTime.now().hour;
    final int minutes = DateTime.now().minute;
    final String hourAndMinutes =
        '${hour.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

    if (userEmail != null) {
      analytics.logEvent(
        name: 'driver_home_open',
        parameters: <String, dynamic>{
          'it_opened': 'true',
          'driver_email': userEmail,
          'hour_logged': hourAndMinutes,
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    ref.read(driverReservesHomeProvider.notifier).reloadData();
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
      'Diciembre'
    ];
    final driverInfo = ref.watch(driverInfoProvider);
    final tripsSummaryDriver = ref.watch(tripsSummaryDriverProvider);
    final nearestReserve = ref.watch(nearestReserveProvider);
    Credentials? credentials = ref.watch(authProvider).credentials;

    final date = DateTime.now().toUtc();
    final reserves = ref.watch(driverReservesHomeProvider);
    Future createTrip(int id, double price) async {
      try {
        final trip = await dio(credentials!.accessToken).post('/trips', data: {
          "reserve_id": id,
          "on_way_driver": roudedDateTimeToString(),
          "totalPrice": price
        });
        return trip.data['id'];
      } catch (e) {
        print(e);
      }
    }

    void nav(id) {
      context.pop();
      context.push('/driver/trips/on-trip/$id');
    }

    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () {
        ref.invalidate(driverInfoProvider);
        return ref.read(driverReservesHomeProvider.notifier).reloadData();
      },
      child: Stack(children: <Widget>[
        Padding(
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
                        color: const Color(0xff03132a),
                      )),
                      SizedBox(
                        width: size.width * .04,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('¡Hola!',
                                style: TextStyle(
                                  fontSize: 32,
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
                          fontSize: 20,
                          fontFamily: 'Roboto-Bold',
                          color: Color(0xff364356)))),
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
                        : const Text('Próxima reserva',
                            style: TextStyle(
                                fontSize: 20, color: Color(0xff364356)));
                  },
                ),
              ),
              const SizedBox(
                height: 15,
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
                            DriverCustomSlide(
                                reserve: nearestReserve, isNearest: true),
                            const SizedBox(
                              height: 15,
                            ),
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
                                        return AlertStartTrip(
                                          ref: ref,
                                          createTrip: createTrip,
                                          nav: nav,
                                          id: nearestReserve.id,
                                          price: nearestReserve.price,
                                        );
                                      },
                                    );
                                  }
                                  if (nearestReserve.tripId != null) {
                                    context.push(
                                        '/driver/trips/on-trip/${nearestReserve.tripId}');
                                  }
                                },
                                style: nearestReserve.startTime
                                            .difference(date)
                                            .inHours <
                                        2
                                    ? ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                        fixedSize: MaterialStateProperty.all(
                                            Size(size.width * .8,
                                                size.height * .06)),
                                        backgroundColor:
                                            nearestReserve.tripId == null
                                                ? MaterialStateProperty.all(
                                                    const Color(0xFF23A5CD))
                                                : MaterialStateProperty.all(
                                                    const Color(0xFF4DD13F)),
                                      )
                                    : ButtonStyle(
                                        shape:
                                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                        fixedSize: nearestReserve.startTime
                                                    .difference(date)
                                                    .inHours <
                                                2
                                            ? MaterialStateProperty.all(Size(
                                                size.width * .8,
                                                size.height * .06))
                                            : MaterialStateProperty.all(
                                                const Size(0.0, 0.0)),
                                        backgroundColor: nearestReserve.tripId ==
                                                null
                                            ? nearestReserve.startTime
                                                        .difference(date)
                                                        .inHours <
                                                    2
                                                ? MaterialStateProperty.all(const Color(0xFF23A5CD))
                                                : MaterialStateProperty.all(const Color(0xFFFDFDFD))
                                            : MaterialStateProperty.all(const Color(0xFF4DD13F))),
                                child: nearestReserve.startTime
                                            .difference(date)
                                            .inHours <
                                        2
                                    ? Text(
                                        nearestReserve.tripId == null
                                            ? 'Voy en camino'
                                            : 'Ver viaje en curso',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ))
                                    : const SizedBox(),
                              ),
                            ),
                          ],
                        )
                      : const Center(child: Text('No hay reserva próxima'));
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text('Reservas del día',
                    style: TextStyle(fontSize: 20, color: Color(0xff364356))),
              ),
              const SizedBox(
                height: 15,
              ),
              DriverReservesListHome(
                reserves: reserves,
                loadNextPage: () {
                  ref.read(driverReservesHomeProvider.notifier).loadNextPage();
                },
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * .25, child: ListView()),
      ]),
    );
  }
}
