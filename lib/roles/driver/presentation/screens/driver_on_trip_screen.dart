import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_state_provider.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_arrived_driver_trip.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_cancelated_trip.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_end_trip.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_start_time_driver.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_additional_information.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_see_map_detail.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_trip_status.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_trip_status_text.dart';
import 'package:silverapp/roles/driver/presentation/widgets/buttons/button_driver.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_screen/address_info.dart';
import 'package:silverapp/roles/driver/presentation/widgets/title_reserve.dart';

import '../widgets/buttons/button_back_home.dart';

class DriverOnTripScreen extends ConsumerStatefulWidget {
  const DriverOnTripScreen({super.key, required this.tripId});

  final String tripId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      DriverOnTripScreenState();
}

class DriverOnTripScreenState extends ConsumerState<DriverOnTripScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(tripDriverStatusProvider.notifier).loadTripState(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    final trips = ref.watch(tripDriverStatusProvider);
    final TripDriverStatus? trip = trips[widget.tripId];
    void reload() {
      ref.invalidate(tripDriverStatusProvider);
      ref.read(tripDriverStatusProvider.notifier).loadTripState(widget.tripId);
    }

    if (trip == null) {
      return Scaffold(
          backgroundColor: Colors.grey[200],
          body: const Center(
            child: CircularProgressIndicator(),
          ));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Viaje en curso'),
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
            child: TripInfo(
              trip: trip,
              reload: reload,
            )));
  }
}

class TripInfo extends ConsumerWidget {
  const TripInfo({
    Key? key,
    required this.trip,
    required this.reload,
  }) : super(key: key);
  final VoidCallback reload;
  final TripDriverStatus trip;

  Widget getAlertWidget() {
    if (trip.arrivedDriver != null) {
      return TripButton(
          buttonText: "Iniciar viaje",
          alertWidget: AlertStartTimeDriver(tripId: trip.id, reload: reload));
    }
    return TripButton(
        buttonText: "Llegué al punto de recojo",
        alertWidget: AlertArrivedDriver(tripId: trip.id, reload: reload));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (trip.status == "CANCELED") {
      context.pop("/driver");
    }
    return ListView(children: [
      const SeeMap(),
      AddressInfoWidget(
          startAddress: trip.startAddress, endAddress: trip.endAddress),
      TripStatus(
          arrivedDriver: trip.arrivedDriver,
          startTime: trip.startTime,
          endTime: trip.endTime),
      const TripStatusText(),
      trip.startTime == null && trip.endTime == null
          ? getAlertWidget()
          : const SizedBox(),
      const SizedBox(
        height: 10,
      ),
      trip.arrivedDriver != null &&
              trip.startTime == null &&
              trip.endTime == null
          ? TextButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertTripCancelated(
                        tripId: trip.id,
                        reload: reload,
                      )),
              child: const Text(
                "El pasajero no se presento",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: "Monserrat",
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ))
          : const SizedBox(),
      const SizedBox(
        height: 10,
      ),
      trip.arrivedDriver == null
          ? const SizedBox()
          : const TitleReserve(text: "Informacion adicional"),
      const SizedBox(
        height: 5,
      ),
      trip.arrivedDriver == null
          ? const SizedBox()
          : AdditionalInformation(
              boolValue: trip.endTime == null ? true : false,
              reload: reload,
              tripId: trip.id,
              stops: trip.stops,
              observations: trip.observations,
              parkings: trip.parkings,
              tolls: trip.tolls,
            ),
      trip.startTime != null && trip.endTime == null
          ? TripButton(
              buttonText: "Finalizar viaje",
              alertWidget: AlertTripEnd(tripId: trip.id, reload: reload))
          : const SizedBox(),
      trip.endTime == null
          ? const SizedBox()
          : const BackHomeButton(buttonText: "Volver al inicio")
    ]);
  }
}
