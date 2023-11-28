import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_state_provider.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_arrived_driver_trip.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_canceled_trip.dart';
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
  double calculateCustomerPrice() {
    double result = trip.totalPrice;
    for (var element in trip.tolls) {
      result += element.amount;
    }
    for (var element in trip.parkings) {
      result += element.amount;
    }
    return result;
  }

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
    const TextStyle textStyleLastGoodbye = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15);

    return ListView(children: [
      SeeMap(
        startAddress: trip.startAddress,
        startAddressLat: trip.startAddressLat,
        startAddressLon: trip.startAddressLon,
        endAddress: trip.endAddress,
        endAddressLat: trip.endAddressLat,
        endAddressLon: trip.endAddressLon,
        arrivedDriver: trip.arrivedDriver,
        startTime: trip.startTime,
        endTime: trip.endTime,
      ),
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
          ? Container(
              padding: const EdgeInsets.all(5),
              child: TextButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertTripCanceled(
                            tripId: trip.id,
                            reload: reload,
                          )),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(10)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: const Text(
                    "El pasajero no se presento",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "Monserrat",
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  )),
            )
          : const SizedBox(),
      const SizedBox(
        height: 10,
      ),
      trip.arrivedDriver == null
          ? const SizedBox()
          : const TitleReserve(text: "Información adicional"),
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
              tripType: trip.tripType,
              reserveId: trip.reserveId,
            ),
      trip.startTime != null && trip.endTime == null
          ? Container(
              padding: const EdgeInsets.all(10),
              child: TripButton(
                  buttonText: "Finalizar viaje",
                  alertWidget: AlertTripEnd(
                      tripId: trip.id,
                      reload: reload,
                      tripType: trip.tripType,
                      arrivedDriver: trip.arrivedDriver)),
            )
          : const SizedBox(),
      trip.endTime != null
          ? Row(children: [
              const Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Precio",
                      style: TextStyle(
                        fontFamily: "Raleway",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                  Text("Cliente",
                      style: TextStyle(
                        fontFamily: "Raleway",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              )),
              Expanded(
                  child: Text("S/  ${calculateCustomerPrice()}",
                      style: const TextStyle(
                        fontFamily: "Raleway",
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ))),
            ])
          : const SizedBox(
              height: 5,
            ),
      trip.endTime != null
          ? const Column(
              children: [
                Text(
                  "Datos enviados",
                  style: textStyleLastGoodbye,
                ),
                Text("¡Muchas gracias!", style: textStyleLastGoodbye)
              ],
            )
          : const SizedBox(),
      trip.endTime == null
          ? const SizedBox()
          : Container(
              padding: const EdgeInsets.all(10),
              child: const BackHomeButton(buttonText: "Volver al inicio"))
    ]);
  }
}
