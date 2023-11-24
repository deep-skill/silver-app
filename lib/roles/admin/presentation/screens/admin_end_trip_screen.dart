import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminTripDetailScreen extends ConsumerStatefulWidget {
  const AdminTripDetailScreen({super.key, required this.tripId});

  final String tripId;

  @override
  AdminTripDetailScreenState createState() => AdminTripDetailScreenState();
}

class AdminTripDetailScreenState extends ConsumerState<AdminTripDetailScreen> {
  @override
  void initState() {
    super.initState();
    /*    ref
        .read(driverReserveDetailProvider.notifier)
        .loadReserveDetail(widget.reserveId); */
  }

  @override
  Widget build(BuildContext context) {
/*     final reserves = ref.watch(driverReserveDetailProvider);
    final DriverReserveDetail? reserve = reserves[widget.reserveId]; */
    final trip = widget.tripId;
    if (trip == null) {
      return Scaffold(
          backgroundColor: Colors.grey[200],
          body: const Center(
            child: CircularProgressIndicator(),
          ));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalles'),
          centerTitle: true,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            padding: const EdgeInsets.all(3),
            child: Text(trip)));
  }
}
