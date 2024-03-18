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
import 'package:silverapp/roles/driver/presentation/widgets/label_trip_extra_end.dart';
import 'package:silverapp/roles/driver/presentation/widgets/title_additional_information.dart';
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
          title: const Text('Detalles del viaje'),
          centerTitle: true,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(10.0),
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

    final Size size = MediaQuery.of(context).size;
    double calculateDriverPrice() {
      double result =
          trip.totalPrice - (trip.totalPrice * trip.silverPercent / 100);
      for (var element in trip.tolls) {
        result += element.amount;
      }
      for (var element in trip.parkings) {
        result += element.amount;
      }
      return result;
    }

    final String reserveStartTimeMinute =
        trip.reserveStartTime.minute.toString().padLeft(2, '0');

    return ListView(shrinkWrap: true, children: [
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
          trip.serviceType != "PERSONAL"
              ? BoxReserveDetail(
                  icon: Icons.domain,
                  label: "Empresa",
                  text: trip.enterpriseName ?? 'Viaje Personal',
                  row: false)
              : const SizedBox(height: 10),
          BoxReserveDetail(
              icon: Icons.business_center_outlined,
              label: "Tipo de servicio",
              text:
                  trip.serviceType == 'ENTERPRISE' ? 'Empresarial' : 'Personal',
              row: false),
          const SizedBox(height: 10),
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
                        '${trip.reserveStartTime.hour}:$reserveStartTimeMinute',
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
          SizedBox(
            height: size.width * 0.03,
          ),
          trip.tolls.isEmpty
              ? const SizedBox()
              : DriverTripLabelToll(
                  label: "Peaje", tolls: trip.tolls, icon: Icons.paid),
          trip.parkings.isEmpty
              ? const SizedBox()
              : DriverTripLabelParking(
                  label: "Estacionamiento",
                  parkings: trip.parkings,
                  icon: Icons.local_parking),
          trip.observations.isEmpty
              ? const SizedBox()
              : DriverTripLabelObservation(
                  label: "Observaciones",
                  observations: trip.observations,
                  icon: Icons.search),
          trip.waitingTimeExtra != null
              ? const TitleAdditionalInformation(
                  icon: Icons.more_time_rounded,
                  label: "Tiempo de espera",
                )
              : const SizedBox(),
          trip.waitingTimeExtra != null
              ? LabelExtraTripEnd(text: trip.waitingTimeExtra.toString())
              : const SizedBox(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * .01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pago Conductor',
                  style: TextStyle(fontSize: 24.0, fontFamily: 'Raleway-Bold'),
                ),
                Text(
                  'S/ ${calculateDriverPrice().toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 24.0, fontFamily: 'Montserrat-Semi-Bold'),
                )
              ],
            ),
          ),
          SizedBox(
            height: size.width * 0.03,
          ),
        ]),
      )
    ]);
  }
}
