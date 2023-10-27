import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_detail.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/silver_percent.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_detail_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/box_reserve_detail.dart';
import 'package:silverapp/roles/admin/presentation/widgets/box_reserve_payment.dart';

class ReserveDetailScreen extends ConsumerStatefulWidget {
  const ReserveDetailScreen({super.key, required this.reserveId});

  final String reserveId;
  // final double silverPayment;
  @override
  ReserveDetailScreenState createState() => ReserveDetailScreenState();
}

class ReserveDetailScreenState extends ConsumerState<ReserveDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref
        .read(reserveDetailProvider.notifier)
        .loadReserveDetail(widget.reserveId);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final reserves = ref.watch(reserveDetailProvider);
    final ReserveDetail? reserve = reserves[widget.reserveId];

    if (reserve == null) {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
        appBar: AppBar(
            title: const Text('Detalle de reserva'),
            scrolledUnderElevation: 0.0),
        body: Padding(
            padding: const EdgeInsets.all(12),
            child: ReserveInfo(reserve: reserve, size: size)));
  }
}

class ReserveInfo extends StatelessWidget {
  ReserveInfo({super.key, required this.reserve, required this.size});
  final ReserveDetail reserve;
  final Size size;

  @override
  Widget build(BuildContext context) {
    const cyanColor = Color(0xff23a5cd);
    final siverPercentToDouble = double.parse(reserve.silverPercent) / 100;
    final priceToDouble = double.parse(reserve.price);
    final double silverPercent =
        double.parse((siverPercentToDouble * priceToDouble).toStringAsFixed(2));
    final double driverPayment = priceToDouble - silverPercent;
    return Expanded(
      child: ListView(
        children: [
          Container(
            height: size.height,
            decoration: const BoxDecoration(
              color: Color(0xffF2F3F7),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Datos Del Servicio',
                      style: TextStyle(color: cyanColor)),
                  const Divider(color: cyanColor),
                  BoxReserveDetail(
                      icon: Icons.hail,
                      label: 'Pasajero',
                      text: '${reserve.name} ${reserve.lastName}'),
                  BoxReserveDetail(
                      icon: Icons.domain,
                      label: 'Empresa',
                      text: '${reserve.brand}'),
                  BoxReserveDetail(
                      icon: Icons.business_center_outlined,
                      label: 'Tipo de Servicio',
                      text: '${reserve.serviceType}'),
                  const Text('Datos Del Viaje',
                      style: TextStyle(color: cyanColor)),
                  const Divider(color: cyanColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: BoxReserveDetail(
                            icon: Icons.today,
                            label: 'Fecha de Reserva',
                            text:
                                '${reserve.startTime.day}/${reserve.startTime.month}/${reserve.startTime.year}'),
                      ),
                      Expanded(
                        child: BoxReserveDetail(
                            label: 'Hora de reserva',
                            text:
                                '${reserve.startTime.hour}:${reserve.startTime.minute}'),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: BoxReserveDetail(
                            icon: Icons.timeline,
                            label: 'Tipo de viaje',
                            text: '${reserve.tripType}'),
                      ),
                      Expanded(
                        child: BoxReserveDetail(label: 'Estado', text: '-'),
                      ), //falta traer del back el estado de la reserva,la relacion reserva, viaje, cuenta con el estado,solamnete hay que traerlo
                    ],
                  ),
                  BoxReserveDetail(
                      icon: Icons.location_on,
                      label: 'Punto de recojo',
                      text: '${reserve.startAddress}'),
                  BoxReserveDetail(
                      icon: Icons.trip_origin_outlined,
                      label: 'Punto de destino',
                      text: '${reserve.endAddress}'),
                  const Text('Datos del conductor y vehículo',
                      style: TextStyle(color: cyanColor)),
                  const Divider(color: cyanColor),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BoxReserveDetail(
                                icon: Icons.person_2_outlined,
                                label: 'Conductor',
                                text: reserve.driverName != null
                                    ? '${reserve.driverName} ${reserve.lastName}'
                                    : '-'), //driverName es == ''
                            BoxReserveDetail(
                                icon: Icons.drive_eta_rounded,
                                label: 'Marca/ modelo/ color',
                                text:
                                    '${reserve.brand}/ ${reserve.model}/ ${reserve.color}'),
                            BoxReserveDetail(
                                icon: Icons.money,
                                label: 'Placa',
                                text: '${reserve.licensePlate}'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Center(
                              // Posición desde la izquierda
                              child: ClipOval(
                                  child: Image.asset(
                                'assets/images/driver_img_example.png',
                                scale: 0.5,
                              )), // Widget que quieres mostrar en esta posición
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Image.asset(
                                'assets/images/vehiculo_home_admin.png',
                                scale: 0.7,
                              ), // Puedes usar cualquier widget aquí
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BoxReservePayment(
                          label: 'Tarifa base', text: 'S/${reserve.price}'),
                      BoxReservePayment(
                          label: 'Pago Silver', text: 'S/${silverPercent}'),
                      BoxReservePayment(
                          label: 'Pago conductor', text: 'S/${driverPayment}'),
                      BoxReservePayment(
                          label: 'Porcentaje Silver',
                          text: '${reserve.silverPercent}%'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                          fixedSize: MaterialStateProperty.all(
                              Size(size.width * .45, size.height * .06)),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF23A5CD)),
                        ),
                        child: const Text('Editar Información',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                    '¿Estás seguro de que deseas cancelar el viaje?',
                                    textAlign: TextAlign.center),
                                content: const Text(
                                  'No podrás volver a activar el recorrido.',
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xff23A5CD)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    child: const Text('Confirmar'),
                                    onPressed: () {},
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: const Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                          color: Colors.black, width: 2))),
                          fixedSize: MaterialStateProperty.all(
                              Size(size.width * .4, size.height * .06)),
                          backgroundColor:
                              MaterialStateProperty.all(const Color(0xFFFFFF)),
                        ),
                        child: const Text('Cancelar viaje',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
