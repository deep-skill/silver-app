import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_state_provider.dart';

class DriverOnTripScreen extends ConsumerStatefulWidget {
  const DriverOnTripScreen({super.key, required this.tripId});

  final String tripId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ReserveDetailScreenState();
}

class ReserveDetailScreenState extends ConsumerState<DriverOnTripScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(tripDriverStatusProvider.notifier).loadTripState(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    final trips = ref.watch(tripDriverStatusProvider);
    final TripDriverStatus? trip = trips[widget.tripId];
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
            child: TripInfo(trip: trip)));
  }
}

class TripInfo extends StatelessWidget {
  const TripInfo({
    super.key,
    required this.trip,
  });
  final TripDriverStatus trip;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Text(trip.id.toString()),
            Text(trip.endAddress),
            Text(trip.startAddress),
            Text(trip.totalPrice.toString()),
          ],
        ),
      ],
    );
  }
}
