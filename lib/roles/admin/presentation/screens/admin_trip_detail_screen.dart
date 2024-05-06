import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_end_detail.dart';
import 'package:silverapp/roles/admin/presentation/providers/trip_detail_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/admin_end_trip/box_additional_information.dart';
import 'package:silverapp/roles/admin/presentation/widgets/admin_end_trip/expansion_trip_toll_parking.dart';
import 'package:silverapp/roles/admin/presentation/widgets/admin_end_trip/label_driver_silver_earn.dart';
import 'package:silverapp/roles/admin/presentation/widgets/admin_end_trip/expansion_trip_label_amout.dart';
import 'package:silverapp/roles/admin/presentation/widgets/admin_end_trip/laber_total_price.dart';
import 'package:silverapp/roles/admin/presentation/widgets/box_status_reserve_detail.dart';
import 'package:silverapp/roles/admin/presentation/widgets/box_reserve_detail.dart';
import 'package:silverapp/roles/admin/presentation/widgets/title_trip_detail.dart';

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
    ref.read(tripAdminStatusProvider.notifier).updateTripStatus(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    Credentials? credentials = ref.watch(authProvider).credentials;
    final trips = ref.watch(tripAdminStatusProvider);
    final AdminTripEnd? trip = trips[widget.tripId];

    if (trip == null) {
      return Scaffold(
          backgroundColor: Colors.grey[200],
          body: const Center(
            child: CircularProgressIndicator(),
          ));
    }

    void reload() {
      ref.invalidate(tripAdminStatusProvider);
      ref.read(tripAdminStatusProvider.notifier).loadTripState(widget.tripId);
    }

    String capitalizeFirst(String input) {
      return input[0].toUpperCase() + input.substring(1).toLowerCase();
    }

    double calculateCustomerPrice() {
      double result = trip.totalPrice;
      for (var element in trip.tolls) {
        result += element.amount;
      }
      for (var element in trip.parkings) {
        result += element.amount;
      }
      if (trip.waitingTimeExtra != null) {
        result += trip.waitingTimeExtra!;
      }
      return result;
    }

    double calculatePaySilver() {
      if (trip.status == "CANCELED") {
        return trip.totalPrice * trip.silverPercent / 100;
      }
      if (trip.waitingTimeExtra != null) {
        return (trip.totalPrice + trip.waitingTimeExtra!) *
            trip.silverPercent /
            100;
      }
      double result = trip.totalPrice * trip.silverPercent / 100;
      return result;
    }

    double calculatePayDriver() {
      double result = trip.totalPrice - calculatePaySilver();
      if (trip.waitingTimeExtra != null) {
        result += trip.waitingTimeExtra!;
      }

      return result;
    }

    double? calcualteToll() {
      if (trip.tolls.isEmpty) return null;
      double result = 0.0;
      for (var element in trip.tolls) {
        result += element.amount;
      }
      return result;
    }

    double? calculateParking() {
      if (trip.parkings.isEmpty) return null;
      double result = 0.0;
      for (var element in trip.parkings) {
        result += element.amount;
      }
      return result;
    }

    return kIsWeb
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Detalles'),
              centerTitle: true,
              backgroundColor: const Color(0xffF2F3F7),
            ),
            body: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .40,
                                child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        const TitleTripDetail(
                                            text: "Datos del servicio"),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment: trip.serviceType ==
                                                  "PERSONAL"
                                              ? MainAxisAlignment.spaceAround
                                              : MainAxisAlignment.spaceBetween,
                                          children: [
                                            BoxReserveDetail(
                                                label: "Pasajero",
                                                text:
                                                    "${trip.userName} ${trip.userLastName}",
                                                icon: Icons.hail,
                                                row: true),
                                            trip.serviceType != "PERSONAL"
                                                ? BoxReserveDetail(
                                                    label: "Empresa",
                                                    text: trip.enterpriseName ==
                                                            null
                                                        ? 'Viaje Personal'
                                                        : trip.enterpriseName
                                                            .toString(),
                                                    icon: Icons.domain,
                                                    row: true)
                                                : const SizedBox(
                                                    height: 10,
                                                  ),
                                            BoxReserveDetail(
                                                label: "Tipo de servicio",
                                                text: trip.serviceType ==
                                                        'ENTERPRISE'
                                                    ? 'Empresarial'
                                                    : 'Personal',
                                                icon: Icons
                                                    .business_center_outlined,
                                                row: true),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Column(
                                      children: [
                                        const TitleTripDetail(
                                            text:
                                                "Datos del conductor y vehículo"),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      BoxReserveDetail(
                                                          label: "Conductor",
                                                          text:
                                                              "${trip.driverName} ${trip.driverLastName}",
                                                          icon: Icons
                                                              .person_2_outlined,
                                                          row: true),
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .07),
                                                      BoxReserveDetail(
                                                          label:
                                                              "Marca/ modelo/ color",
                                                          text:
                                                              "${trip.brand} ${trip.model} ${trip.color}",
                                                          icon: Icons
                                                              .person_2_outlined,
                                                          row: true),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .03),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      BoxReserveDetail(
                                                          label: "Placa",
                                                          text:
                                                              trip.licensePlate,
                                                          icon: Icons.money,
                                                          row: true),
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .15),
                                                      Stack(
                                                        children: [
                                                          SizedBox(
                                                            width: 100,
                                                            height: 100,
                                                            child: ClipOval(
                                                                child: trip.driverImageUrl !=
                                                                        null
                                                                    ? Image
                                                                        .network(
                                                                        trip.driverImageUrl!,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )
                                                                    : Image.asset(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        'assets/images/driver_img_example.png')),
                                                          ),
                                                          Positioned(
                                                            bottom: -4,
                                                            left: -12,
                                                            child: Image.asset(
                                                              'assets/images/vehiculo_home_admin.png',
                                                              scale: 0.9,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 18,
                                        ),
                                        const TitleTripDetail(
                                            text: "Detalle de pago"),
                                        const SizedBox(
                                          height: 9,
                                        ),
                                        trip.tripPolyline == 'error google'
                                            ? const Text(
                                                'Error en el calculo recalcular',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12),
                                              )
                                            : const SizedBox(),
                                        const SizedBox(
                                          height: 9,
                                        ),
                                        ExpansionTripLabelAmout(
                                          priceBase: trip.totalPrice,
                                          waitingTimeExtra:
                                              trip.waitingTimeExtra,
                                          suggestedTotalPrice:
                                              trip.suggestedTotalPrice,
                                        ),
                                        LabelDriverSilverWin(
                                          description:
                                              'Gana Silver (${trip.silverPercent}%)',
                                          priceText:
                                              "S/ ${calculatePaySilver().toStringAsFixed(2)}",
                                        ),
                                        LabelDriverSilverWin(
                                          description: 'Gana Conductor',
                                          priceText:
                                              "S/ ${calculatePayDriver().toStringAsFixed(2)}",
                                        ),
                                        if (calcualteToll() != null ||
                                            calculateParking() != null)
                                          ExpansionTripLabelTollParking(
                                            priceParking: calculateParking(),
                                            priceToll: calcualteToll(),
                                          ),
                                        LabelTotalPrice(
                                          description: "Precio total",
                                          priceText:
                                              "S/ ${calculateCustomerPrice().toStringAsFixed(2)}",
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                            "*Incluye gastos de peaje y/o estacionamiento"),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .30,
                                child: Column(
                                  children: [
                                    const TitleTripDetail(
                                        text: "Datos del viaje"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: BoxReserveDetail(
                                              label: "Fecha de inicio",
                                              text:
                                                  '${trip.onWayDriver.day}/${trip.onWayDriver.month}/${trip.onWayDriver.year}',
                                              icon: Icons.today,
                                              row: true),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: BoxReserveDetail(
                                              label: "Hora de reserva",
                                              text:
                                                  '${trip.reserveStartTime.hour.toString().padLeft(2, '0')}:${trip.reserveStartTime.minute.toString().padLeft(2, '0')}',
                                              icon: Icons.alarm,
                                              row: true),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: trip.arrivedDriver != null
                                              ? BoxReserveDetail(
                                                  label: "Hora de llegada",
                                                  text:
                                                      '${trip.arrivedDriver!.hour.toString().padLeft(2, '0')}:${trip.arrivedDriver!.minute.toString().padLeft(2, '0')}',
                                                  icon: Icons.pin_drop_outlined,
                                                  row: true)
                                              : const SizedBox(),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: trip.startTime != null
                                              ? BoxReserveDetail(
                                                  label: "Hora de inicio",
                                                  text:
                                                      '${trip.startTime!.hour.toString().padLeft(2, '0')}:${trip.startTime!.minute.toString().padLeft(2, '0')}',
                                                  icon: Icons
                                                      .airport_shuttle_outlined,
                                                  row: true)
                                              : trip.endTime != null
                                                  ? BoxReserveDetail(
                                                      label: "Hora de fin",
                                                      text:
                                                          '${trip.endTime!.hour.toString().padLeft(2, '0')}:${trip.endTime!.minute.toString().padLeft(2, '0')}',
                                                      icon: Icons
                                                          .av_timer_outlined,
                                                      row: true)
                                                  : const SizedBox(),
                                        ),
                                      ],
                                    ),
                                    if (trip.arrivedDriver != null)
                                      const SizedBox(height: 10),
                                    trip.endTime !=
                                                null &&
                                            trip.startTime != null
                                        ? BoxReserveDetail(
                                            label: "Hora de fin",
                                            text:
                                                '${trip.endTime!.hour.toString().padLeft(2, '0')}:${trip.endTime!.minute.toString().padLeft(2, '0')}',
                                            icon: Icons.av_timer_outlined,
                                            row: true)
                                        : const SizedBox(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: BoxReserveDetail(
                                              label: "Tipo de viaje",
                                              text: capitalizeFirst(
                                                  trip.tripType),
                                              icon: Icons.timeline,
                                              row: true),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: BoxStatusReserveDetail(
                                              tripStatus: trip.status,
                                              label: "Estado"),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    AdminAdditionalInformation(
                                      tripId: trip.id,
                                      startAddress: trip.startAddress,
                                      endAddress: trip.endAddress,
                                      observations: trip.observations,
                                      tolls: trip.tolls,
                                      parkings: trip.parkings,
                                      stops: trip.stops,
                                      reload: reload,
                                      credentials: credentials!.accessToken,
                                      waitingTimeExtra: trip.waitingTimeExtra,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  child: TextButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                            const EdgeInsets.all(5)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color(0xFF03132A)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                      onPressed: () => context.push(
                                          '/admin/reserves/create/${trip.reserveId}'),
                                      child: const Text(
                                        "Editar",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: 'Montserrat-Bold'),
                                      )),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        side: MaterialStateProperty.all(
                                            const BorderSide(
                                                color: Color(0xFF03132A)))),
                                    onPressed: () => context.pop(),
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(
                                          color: Color(0xFF03132A),
                                          fontSize: 16,
                                          fontFamily: 'Montserrat-Bold'),
                                    ),
                                  ),
                                ),
                              ])
                        ],
                      )),
                ),
              ),
            ),
            backgroundColor: const Color(0xffF2F3F7),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xffF2F3F7),
              title: const Text('Detalles'),
              centerTitle: true,
            ),
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: [
                        const TitleTripDetail(text: "Datos del servicio"),
                        const SizedBox(
                          height: 10,
                        ),
                        BoxReserveDetail(
                          label: "Pasajero",
                          text: "${trip.userName} ${trip.userLastName}",
                          icon: Icons.hail,
                        ),
                        const SizedBox(height: 12),
                        trip.serviceType != "PERSONAL"
                            ? BoxReserveDetail(
                                label: "Empresa",
                                text: trip.enterpriseName == null
                                    ? 'Viaje Personal'
                                    : trip.enterpriseName.toString(),
                                icon: Icons.domain,
                              )
                            : const SizedBox(),
                        const SizedBox(height: 12),
                        BoxReserveDetail(
                          label: "Tipo de servicio",
                          text: trip.serviceType == 'ENTERPRISE'
                              ? 'Empresarial'
                              : 'Personal',
                          icon: Icons.business_center_outlined,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const TitleTripDetail(text: "Datos del viaje"),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: BoxReserveDetail(
                                label: "Fecha de inicio",
                                text:
                                    '${trip.onWayDriver.day}/${trip.onWayDriver.month}/${trip.onWayDriver.year}',
                                icon: Icons.today,
                              ),
                            ),
                            Expanded(
                              child: BoxReserveDetail(
                                label: "Hora de reserva",
                                text:
                                    '${trip.reserveStartTime.hour.toString().padLeft(2, '0')}:${trip.reserveStartTime.minute.toString().padLeft(2, '0')}',
                                icon: Icons.alarm,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: trip.arrivedDriver != null
                                  ? BoxReserveDetail(
                                      label: "Hora de llegada",
                                      text:
                                          '${trip.arrivedDriver!.hour.toString().padLeft(2, '0')}:${trip.arrivedDriver!.minute.toString().padLeft(2, '0')}',
                                      icon: Icons.pin_drop_outlined,
                                      row: true)
                                  : const SizedBox(),
                            ),
                            Expanded(
                              child: trip.startTime != null
                                  ? BoxReserveDetail(
                                      label: "Hora de inicio",
                                      text:
                                          '${trip.startTime!.hour.toString().padLeft(2, '0')}:${trip.startTime!.minute.toString().padLeft(2, '0')}',
                                      icon: Icons.airport_shuttle_outlined,
                                      row: true)
                                  : trip.endTime != null
                                      ? BoxReserveDetail(
                                          label: "Hora de fin",
                                          text:
                                              '${trip.endTime!.hour.toString().padLeft(2, '0')}:${trip.endTime!.minute.toString().padLeft(2, '0')}',
                                          icon: Icons.av_timer_outlined,
                                          row: true)
                                      : const SizedBox(),
                            ),
                          ],
                        ),
                        if (trip.arrivedDriver != null)
                          const SizedBox(height: 10),
                        trip.endTime != null && trip.startTime != null
                            ? BoxReserveDetail(
                                label: "Hora de fin",
                                text:
                                    '${trip.endTime!.hour.toString().padLeft(2, '0')}:${trip.endTime!.minute.toString().padLeft(2, '0')}',
                                icon: Icons.av_timer_outlined,
                                row: true)
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: BoxReserveDetail(
                                label: "Tipo de viaje",
                                text: capitalizeFirst(trip.tripType),
                                icon: Icons.timeline,
                              ),
                            ),
                            Expanded(
                              child: BoxStatusReserveDetail(
                                  tripStatus: trip.status, label: "Estado"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        AdminAdditionalInformation(
                          tripId: trip.id,
                          startAddress: trip.startAddress,
                          endAddress: trip.endAddress,
                          observations: trip.observations,
                          tolls: trip.tolls,
                          parkings: trip.parkings,
                          stops: trip.stops,
                          reload: reload,
                          credentials: credentials!.accessToken,
                          waitingTimeExtra: trip.waitingTimeExtra,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const TitleTripDetail(
                            text: "Datos del conductor y vehículo"),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BoxReserveDetail(
                                    label: "Conductor",
                                    text:
                                        "${trip.driverName} ${trip.driverLastName}",
                                    icon: Icons.person_2_outlined,
                                  ),
                                  const SizedBox(height: 12),
                                  BoxReserveDetail(
                                    label: "Marca/ modelo/ color",
                                    text:
                                        "${trip.brand} ${trip.model} ${trip.color}",
                                    icon: Icons.person_2_outlined,
                                  ),
                                  const SizedBox(height: 12),
                                  BoxReserveDetail(
                                    label: "Placa",
                                    text: trip.licensePlate,
                                    icon: Icons.person_2_outlined,
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ClipOval(
                                      child: trip.driverImageUrl != null
                                          ? Image.network(
                                              trip.driverImageUrl!,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/images/driver_img_example.png',
                                              fit: BoxFit.cover,
                                            )),
                                ),
                                Positioned(
                                  bottom: -4,
                                  left: 8,
                                  right: 4,
                                  child: Image.asset(
                                    'assets/images/vehiculo_home_admin.png',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const TitleTripDetail(text: "Detalle de pago"),
                        const SizedBox(
                          height: 5,
                        ),
                        trip.tripPolyline == 'error google'
                            ? const Text(
                                'Error en el calculo recalcular',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 5,
                        ),
                        ExpansionTripLabelAmout(
                          priceBase: trip.totalPrice,
                          waitingTimeExtra: trip.waitingTimeExtra,
                          suggestedTotalPrice: trip.suggestedTotalPrice,
                        ),
                        LabelDriverSilverWin(
                          description: 'Gana Silver (${trip.silverPercent}%)',
                          priceText:
                              "S/ ${calculatePaySilver().toStringAsFixed(2)}",
                        ),
                        LabelDriverSilverWin(
                          description: 'Gana Conductor',
                          priceText:
                              "S/ ${calculatePayDriver().toStringAsFixed(2)}",
                        ),
                        if (calcualteToll() != null ||
                            calculateParking() != null)
                          ExpansionTripLabelTollParking(
                            priceParking: calculateParking(),
                            priceToll: calcualteToll(),
                          ),
                        LabelTotalPrice(
                          description: "Precio total",
                          priceText:
                              "S/ ${calculateCustomerPrice().toStringAsFixed(2)}",
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                            "*Incluye gastos de peaje y/o estacionamiento"),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(children: [
                          Expanded(
                            child: TextButton(
                                style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(5)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xFF23A5CD)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                onPressed: () => context.push(
                                    '/admin/reserves/create/${trip.reserveId}'),
                                child: const Text(
                                  "Editar",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: "Monserrat"),
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  side: MaterialStateProperty.all(
                                      const BorderSide(
                                          color: Color(0xFF23A5CD)))),
                              onPressed: () => context.pop(),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: Color(0xFF23A5CD)),
                              ),
                            ),
                          ),
                        ])
                      ],
                    )),
              ),
            ),
            backgroundColor: const Color(0xffF2F3F7),
          );
  }
}
