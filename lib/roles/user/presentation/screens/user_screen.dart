import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/user/presentation/providers/reserves.dart';
import 'package:silverapp/roles/user/presentation/widgets/reserve_list_view.dart';
import 'package:silverapp/roles/user/presentation/widgets/side_menu.dart';

class UserScreen extends ConsumerWidget {
  static const name = 'user';
  UserScreen({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Credentials? credentials = ref.watch(authProvider).credentials;
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
    ref.read(reservesProvider.notifier).loadNextPage();
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
    final reserves = ref.watch(reservesProvider);
    final date = DateTime.now().month - 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
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
                        Text('Yape Market',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ]),
                  SizedBox(
                    width: size.width * .3,
                  ),
                  SizedBox(
                      child: Image.asset(
                    "assets/images/app_logo.png",
                    width: size.width * .18,
                  )),
                ],
              ),
            ],
          ),
          SizedBox(
            height: size.height * .01,
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
              decoration: const BoxDecoration(
                color: Color(0xff03132a),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              height: 90,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(months[date],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        const Text('Viajes realizados',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Text('S/ 0,00',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              )),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerLeft,
            child: const Text('Próximas reservas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          ),
          ReservesListView(
            reserves: reserves,
            loadNextPage: () {
              ref.read(reservesProvider.notifier).loadNextPage();
            },
          ),
        ],
      ),
    );
  }
}
