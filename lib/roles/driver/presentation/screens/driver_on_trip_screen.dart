import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_state_provider.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_arrived_driver_trip.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_additional_information.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_see_map_detail.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_trip_status.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_trip_status_text.dart';
import 'package:silverapp/roles/driver/presentation/widgets/buttons/button_driver.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_screen/address_info.dart';
import 'package:silverapp/roles/driver/presentation/widgets/title_reserve.dart';
import '../../../../config/dio/dio.dart';

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
            child: TripInfo(trip: trip)));
  }
}

class TripInfo extends StatelessWidget {
  final TripDriverStatus trip;
  const TripInfo({
    super.key,
    required this.trip,
  });

  Widget getAlertWidget() {
    if (trip.startTime != null) {
      return AlertArrivedDriver(tripId: trip.id);
    }
    return AlertArrivedDriver(tripId: trip.id);
  }

  void patchArrivedDrive(BuildContext context) async {
    try {
      final BuildContext currentContext = context;

      print(trip.id);
      await dio.patch('trips/${trip.id}',
          data: {"arrivedDriver": DateTime.now().toIso8601String()});
      Navigator.of(currentContext).pop();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const SeeMap(),
      AddressInfoWidget(
          startAddress: trip.startAddress, endAddress: trip.endAddress),
      // ignore: prefer_const_constructors
      TripStatus(
          arrivedDriver: trip.arrivedDriver,
          startTime: trip.startTime,
          endTime: trip.endTime),
      const TripStatusText(),
      TripButton(
          buttonText: "Llegué al punto de recojo",
          alertWidget: getAlertWidget()),
      const SizedBox(
        height: 10,
      ),

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
          : const AdditionalInformation(boolValue: true)
    ]);
  }
}
