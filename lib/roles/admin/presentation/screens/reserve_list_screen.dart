import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_list_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/reserve_list.dart';

class ReserveListScreen extends StatelessWidget {
  const ReserveListScreen({super.key});
  static const name = 'reserves';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Lista de reservas')),
        body: const ReserveListView());
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          ReservesList(
            reserves: reserves,
            loadNextPage: () {
              ref.read(reservesListProvider.notifier).loadNextPage();
            },
          ),
        ],
      ),
    );
  }
}
