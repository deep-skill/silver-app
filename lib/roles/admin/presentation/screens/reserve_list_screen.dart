import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:silverapp/roles/admin/presentation/providers/reserve_list_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/side_menu.dart';
import 'package:silverapp/roles/admin/views/reserve_list_view.dart';

class ReserveListScreen extends StatelessWidget {
  ReserveListScreen({super.key});
  static const name = 'reserves';

  @override
  Widget build(BuildContext context) {
    return const ReserveListView();
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
    ref.read(reservesListProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final reserves = ref.watch(reservesListProvider);
      final scaffoldKey = GlobalKey<ScaffoldState>();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Reservas'),
        
      ),
      body: Placeholder(),
    );
  }
}


/* ReservesListView(
        reserves: reserves,
        loadNextPage: () {
          ref.read(reservesListProvider.notifier).loadNextPage();
        },
      ), */