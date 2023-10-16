import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_detail.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_reserve_detail_provider.dart';

class DriverReserveDetailScreen extends ConsumerStatefulWidget {
  const DriverReserveDetailScreen({super.key, required this.reserveId});

  final String reserveId;

  @override
  ReserveDetailScreenState createState() => ReserveDetailScreenState();
}

class ReserveDetailScreenState
    extends ConsumerState<DriverReserveDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref
        .read(driverReserveDetailProvider.notifier)
        .loadReserveDetail(widget.reserveId);
  }

  @override
  Widget build(BuildContext context) {
    final reserves = ref.watch(driverReserveDetailProvider);
    final DriverReserveDetail? reserve = reserves[widget.reserveId];
    if (reserve == null) {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
        appBar: AppBar(title: const Text('Detalle de reserva')),
        body: Padding(
            padding: const EdgeInsets.all(12),
            child: ReserveInfo(reserve: reserve)));
  }
}

class ReserveInfo extends StatelessWidget {
  const ReserveInfo({
    super.key,
    required this.reserve,
  });
  final DriverReserveDetail reserve;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(reserve.name),
      Text(reserve.startTime.toString()),
      Text(reserve.lastName),
      Text(reserve.serviceType),
      Text(reserve.entrepriseName),
      Text(reserve.tripType),
      Text(reserve.startAddress),
      Text(reserve.endAddress ?? ''),
      Text(reserve.price),
    ]);
  }
}
