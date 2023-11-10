import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_list_home_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/trip_summary_provider.dart';
import 'package:silverapp/roles/admin/presentation/screens/views/mobile/admin_home_app_view.dart';
import 'package:silverapp/roles/admin/presentation/screens/views/web/admin_home_web_view.dart';
import 'package:silverapp/roles/admin/presentation/widgets/side_menu.dart';

class AdminScreen extends ConsumerWidget {
  static const name = 'admin';
  AdminScreen({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
//    Credentials? credentials = ref.watch(authProvider).credentials;
//    AuthState? authState = ref.watch(authProvider);
    return kIsWeb
        ? Scaffold(
            backgroundColor: const Color(0xffF2F3F7),
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: const Color(0xff164772),
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
          )
        : Scaffold(
            backgroundColor: const Color(0xffF2F3F7),
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
    if (ref.read(reservesHomeProvider.notifier).currentPage == 0)
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
    final tripsSummary = ref.watch(tripsSummaryProvider);

    return kIsWeb
        ? AdminHomeWebView(
            ref: ref,
            size: size,
            months: months,
            date: date,
            tripsSummary: tripsSummary,
            reserves: reserves)
        : AdminHomeAppView(
            ref: ref,
            size: size,
            months: months,
            date: date,
            tripsSummary: tripsSummary,
            reserves: reserves);
  }
}
