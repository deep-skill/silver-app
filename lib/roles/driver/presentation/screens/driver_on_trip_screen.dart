import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_nearest_reserve_provider.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_state_provider.dart';
import 'package:silverapp/roles/driver/presentation/providers/trips_summary_driver_provider.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_arrived_driver_trip.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_canceled_trip.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_end_trip.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_start_time_driver.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_stop.dart';
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

    void cancelReload() {
      ref.invalidate(nearestReserveProvider);
      ref.invalidate(tripsSummaryDriverProvider);
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
          backgroundColor: Color(0xffF2F3F7),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .85,
            margin: const EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(5),
            child: TripInfo(
              trip: trip,
              reload: reload,
              cancelReload: cancelReload,
            )),
        backgroundColor: const Color(0xffF2F3F7));
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
    required this.cancelReload,
  }) : super(key: key);
  final VoidCallback reload;
  final VoidCallback cancelReload;
  final TripDriverStatus trip;

  void addStops(String address, double lat, double lon) async {
    try {
      if (trip.tripType == "POR HORA") {
        await dio.post('reserves/driver-stop/${trip.reserveId}', data: {
          "endAddress": address,
          "endAddressLat": lat,
          "endAddressLon": lon,
          "tripId": trip.id
        });
      } else {
        await dio.post('stops', data: {
          "location": address,
          "lat": lat,
          "lon": lon,
          "tripId": trip.id
        });
      }
      reload();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Widget getAlertWidget() {
    if (trip.arrivedDriver != null) {
      if (trip.endAddress == null) {
        return TripButton(
            buttonText: "Indicar punto de destino",
            alertWidget: AlertStops(addStops));
      }
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
                            cancelReload: cancelReload,
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
                      fontFamily: "Montserrat-Bold",
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
        height: 12,
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
                      totalPrice: trip.totalPrice,
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
                  Text("Precio \nconductor",
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0xff03132A)))
                ],
              )),
              Expanded(
                  child: Text(
                      "S/  ${calculateCustomerPrice().toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 32.0, color: Color(0xff03132A)))),
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
              child: const BackHomeButton(buttonText: "Ir al inicio"))
    ]);
  }
}
