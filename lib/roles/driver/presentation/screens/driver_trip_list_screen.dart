import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_trips_list/box_list_trip.dart';

class DriverTripList extends StatelessWidget {
  const DriverTripList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Historial de viajes'),
          centerTitle: true,
          scrolledUnderElevation: 0,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            padding: const EdgeInsets.all(3),
            child: const ListViewTrip()));
  }
}

class ListViewTrip extends StatelessWidget {
  const ListViewTrip({super.key});

  @override
  Widget build(BuildContext context) {
    return const BoxTripList(
        date: "06/06/2022",
        image: "assets/trip.png",
        name: "Viaje 1",
        stateReserve: "finalizado");
  }
}
