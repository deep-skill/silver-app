import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/admin/entities/reserve_detail.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_detail_provider.dart';

class ReserveDetailScreen extends ConsumerStatefulWidget {
  const ReserveDetailScreen({super.key, required this.reserveId});

  static const name = 'reserve-detail';
  final String reserveId;

  @override
  ReserveDetailScreenState createState() => ReserveDetailScreenState();
}

class ReserveDetailScreenState extends ConsumerState<ReserveDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(reserveDetailProvider.notifier).getReserveDetail(widget.reserveId);
  }

  @override
  Widget build(BuildContext context) {
    final reserves = ref.watch(reserveDetailProvider);
    final ReserveDetail? reserve = reserves[widget.reserveId];
    print(reserves);
    if (reserve == null) {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
        appBar: AppBar(title: const Text('Lista de reservas')),
        body: Padding(
            padding: EdgeInsets.all(12), child: ReserveInfo(reserve: reserve)));
  }
}

class ReserveInfo extends StatelessWidget {
  const ReserveInfo({
    required this.reserve,
  });
  final ReserveDetail reserve;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(reserve.name)]);
  }
}
