import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_end_detail.dart';
import 'package:silverapp/roles/admin/presentation/providers/trip_detail_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/admin_end_trip/box_additional_information.dart';
import 'package:silverapp/roles/admin/presentation/widgets/admin_end_trip/trip_label_amount.dart';
import 'package:silverapp/roles/admin/presentation/widgets/box_status_reserve_detail.dart';
import 'package:silverapp/roles/admin/presentation/widgets/box_reserve_detail.dart';
import 'package:silverapp/roles/admin/presentation/widgets/title_trip_detail.dart';
import 'package:silverapp/roles/admin/presentation/widgets/trip_address_info.dart';

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
    ref.read(tripAdminStatusProvider.notifier).loadTripState(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
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
      return result;
    }

    double calculatePaySilver() {
      double result = trip.totalPrice * trip.silverPercent / 100;
      return result;
    }

    double calculatePayConductor() {
      double result = calculateCustomerPrice() - calculatePaySilver();
      return result;
    }

    return kIsWeb
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Detalles'),
              centerTitle: true,
              backgroundColor: Color(0xffF2F3F7),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            BoxReserveDetail(
                                              label: "Pasajero",
                                              text:
                                                  "${trip.userName} ${trip.userLastName}",
                                              icon: Icons.hail,
                                            ),
                                            BoxReserveDetail(
                                              label: "Empresa",
                                              text: trip.enterpriseName
                                                  .toString(),
                                              icon: Icons.domain,
                                            ),
                                            BoxReserveDetail(
                                              label: "Tipo de servicio",
                                              text: capitalizeFirst(
                                                  trip.serviceType.toString()),
                                              icon: Icons
                                                  .business_center_outlined,
                                            ),
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
                                                      ),
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
                                                      ),
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
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      BoxReserveDetail(
                                                        label: "Placa",
                                                        text: trip.licensePlate,
                                                        icon: Icons.money,
                                                      ),
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .15),
                                                      Expanded(
                                                        child: Stack(
                                                          children: [
                                                            ClipOval(
                                                                child:
                                                                    Image.asset(
                                                              'assets/images/driver_img_example.png',
                                                              scale: 0.7,
                                                            )),
                                                            Positioned(
                                                              bottom: 0,
                                                              left: 0,
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/vehiculo_home_admin.png',
                                                                scale: 0.9,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
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
                                        TripLabelAmout(
                                          textAmout:
                                              "S/ ${calculateCustomerPrice().toStringAsFixed(2)}",
                                          textTipePrice: "Precio Total*",
                                        ),
                                        TripLabelAmout(
                                          textAmout:
                                              "S/ ${calculatePayConductor().toStringAsFixed(2)}",
                                          textTipePrice: "Pago conductor",
                                        ),
                                        TripLabelAmout(
                                          textAmout:
                                              "S/ ${calculatePaySilver().toStringAsFixed(2)}",
                                          textTipePrice: "Pago Silver",
                                        ),
                                        TripLabelAmout(
                                          textAmout: "${trip.silverPercent}%",
                                          textTipePrice: "Porcentaje Silver",
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
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: BoxReserveDetail(
                                            label: "Hora de reserva",
                                            text:
                                                '${trip.onWayDriver.hour}:${trip.onWayDriver.minute}',
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
                                          child: BoxReserveDetail(
                                            label: "Tipo de viaje",
                                            text:
                                                capitalizeFirst(trip.tripType),
                                            icon: Icons.timeline,
                                          ),
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
                                    TripAddressInfoWidget(
                                      startAddress: trip.startAddress,
                                      endAddress: trip.endAddress,
                                      stops: trip.stops,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    AdminAdditionalInformation(
                                      tripId: trip.id,
                                      observations: trip.observations,
                                      tolls: trip.tolls,
                                      parkings: trip.parkings,
                                      stops: trip.stops,
                                      reload: reload,
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
                      color: Colors.grey[200],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: [
                        const TitleTripDetail(text: "Datos del servicio"),
                        const SizedBox(
                          height: 5,
                        ),
                        BoxReserveDetail(
                          label: "Pasajero",
                          text: "${trip.userName} ${trip.userLastName}",
                          icon: Icons.hail,
                        ),
                        BoxReserveDetail(
                          label: "Empresa",
                          text: trip.enterpriseName.toString(),
                          icon: Icons.domain,
                        ),
                        BoxReserveDetail(
                          label: "Tipo de servicio",
                          text: capitalizeFirst(trip.serviceType.toString()),
                          icon: Icons.business_center_outlined,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const TitleTripDetail(text: "Datos del viaje"),
                        const SizedBox(
                          height: 5,
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
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: BoxReserveDetail(
                                label: "Hora de reserva",
                                text:
                                    '${trip.onWayDriver.hour}:${trip.onWayDriver.minute}',
                                icon: Icons.alarm,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: BoxReserveDetail(
                                label: "Tipo de viaje",
                                text: capitalizeFirst(trip.tripType),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            BoxStatusReserveDetail(
                                tripStatus: trip.status, label: "Estado"),
                          ],
                        ),
                        TripAddressInfoWidget(
                          startAddress: trip.startAddress,
                          endAddress: trip.endAddress,
                          stops: trip.stops,
                        ),
                        AdminAdditionalInformation(
                          tripId: trip.id,
                          observations: trip.observations,
                          tolls: trip.tolls,
                          parkings: trip.parkings,
                          stops: trip.stops,
                          reload: reload,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const TitleTripDetail(
                            text: "Datos del conductor y vehículo"),
                        const SizedBox(
                          height: 5,
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
                                  BoxReserveDetail(
                                    label: "Marca/ modelo/ color",
                                    text:
                                        "${trip.brand} ${trip.model} ${trip.color}",
                                    icon: Icons.person_2_outlined,
                                  ),
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
                                Center(
                                  child: ClipOval(
                                      child: Image.asset(
                                    'assets/images/driver_img_example.png',
                                    scale: 0.5,
                                  )),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Image.asset(
                                    'assets/images/vehiculo_home_admin.png',
                                    scale: 0.7,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TripLabelAmout(
                          textAmout:
                              "S/ ${calculateCustomerPrice().toStringAsFixed(2)}",
                          textTipePrice: "Precio Total*",
                        ),
                        TripLabelAmout(
                          textAmout:
                              "S/ ${calculatePayConductor().toStringAsFixed(2)}",
                          textTipePrice: "Pago conductor",
                        ),
                        TripLabelAmout(
                          textAmout:
                              "S/ ${calculatePaySilver().toStringAsFixed(2)}",
                          textTipePrice: "Pago Silver",
                        ),
                        TripLabelAmout(
                          textAmout: "${trip.silverPercent}%",
                          textTipePrice: "Porcentaje Silver",
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
            ));
  }
}
