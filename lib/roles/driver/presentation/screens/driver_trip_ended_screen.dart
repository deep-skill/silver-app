import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_state_provider.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_state_reserve_detail.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_reserve_detail.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_trip_address_info_widget.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_trip_ended_widgets/driver_trip_label_observation.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_trip_ended_widgets/driver_trip_label_parking.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_trip_ended_widgets/driver_trip_label_toll.dart';
import 'package:silverapp/roles/driver/presentation/widgets/title_reserve_detail.dart';

class DriverTripEndedScreen extends ConsumerStatefulWidget {
  const DriverTripEndedScreen({super.key, required this.tripId});

  final String tripId;

  @override
  DriverTripEndedScreenState createState() => DriverTripEndedScreenState();
}

class DriverTripEndedScreenState extends ConsumerState<DriverTripEndedScreen> {
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
            child: TripEndedInfo(trip: trip)));
  }
}

class TripEndedInfo extends StatelessWidget {
  const TripEndedInfo({
    super.key,
    required this.trip,
  });
  final TripDriverStatus trip;

  @override
  Widget build(BuildContext context) {
    String capitalizeFirst(String input) {
      return input[0].toUpperCase() + input.substring(1).toLowerCase();
    }

    // print('tolls ${trip.tolls[0].name}');
    // double driverIncome(price, silverPercent) {
    //   return price - ((price / 100) * silverPercent);
    // }
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const TitleReserveDetail(text: "Datos del servicio"),
          const SizedBox(
            height: 10,
          ),
          BoxReserveDetail(
              icon: Icons.hail,
              label: "Pasajero",
              text: "${trip.userName} ${trip.userLastName}",
              row: false),
          BoxReserveDetail(
              icon: Icons.domain,
              label: "Empresa",
              text: trip.enterpriseName ?? 'Viaje Personal',
              row: false),
          BoxReserveDetail(
              icon: Icons.business_center_outlined,
              label: "Tipo de servicio",
              text: capitalizeFirst(trip.serviceType),
              row: false),
          const TitleReserveDetail(text: "Datos del viaje"),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: BoxReserveDetail(
                    icon: Icons.today,
                    label: "Fecha de reserva",
                    text:
                        '${trip.reserveStartTime.day}/${trip.reserveStartTime.month}/${trip.reserveStartTime.year}',
                    row: true),
              ),
              Expanded(
                child: BoxReserveDetail(
                    icon: Icons.alarm,
                    label: "Hora de reserva",
                    text:
                        '${trip.reserveStartTime.hour}:${trip.reserveStartTime.minute}',
                    row: true),
              ),
            ],
          ),
          Row(children: [
            Expanded(
              child: BoxReserveDetail(
                  icon: Icons.timeline,
                  label: "Tipo de viaje",
                  text: capitalizeFirst(trip.tripType),
                  row: true),
            ),
            Expanded(
              child: BoxStateReserveDetail(
                icon: Icons.cached,
                label: "Estado",
                state: trip.status,
              ),
            )
          ]),
          DriverTripAddressInfoWidget(
              startAddress: trip.startAddress,
              endAddress: trip.endAddress,
              stops: trip.stops),
          DriverTripLabelToll(
              label: "Peaje", tolls: trip.tolls, icon: Icons.paid),
          DriverTripLabelParking(
              label: "Estacionamiento",
              parkings: trip.parkings,
              icon: Icons.local_parking),
          DriverTripLabelObservation(
              label: "Observaciones",
              observations: trip.observations,
              icon: Icons.search)
        ]),
      )
    ]);
  }
}
