import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_detail.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_detail_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_list_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/box_status_reserve_detail.dart';
import 'package:silverapp/roles/admin/presentation/widgets/box_reserve_detail.dart';
import 'package:silverapp/roles/admin/presentation/widgets/box_reserve_payment.dart';

class ReserveDetailScreen extends ConsumerStatefulWidget {
  const ReserveDetailScreen({super.key, required this.reserveId});

  final String reserveId;
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

  void reload() {
    ref.invalidate(reservesListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final reserves = ref.watch(reserveDetailProvider);
    final ReserveDetail? reserve = reserves[widget.reserveId];
    Credentials? credentials = ref.watch(authProvider).credentials;

    void deleteReserve() async {
      try {
        await dio(credentials!.accessToken).delete('reserves/${reserve?.id}');
      } catch (e) {
        print(e);
      }
      reload();
    }

    if (reserve == null) {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }

    return kIsWeb
        ? Scaffold(
            backgroundColor: const Color(0xffF2F3F7),
            appBar: AppBar(
                backgroundColor: const Color(0xffF2F3F7),
                title: const Text('Detalle de reserva'),
                scrolledUnderElevation: 0.0),
            body: Padding(
                padding: const EdgeInsets.fromLTRB(180, 20, 180, 20),
                child: ReserveInfo(
                  reserve: reserve,
                  size: size,
                  deleteReserve: deleteReserve,
                )))
        : Scaffold(
            backgroundColor: const Color(0xffF2F3F7),
            appBar: AppBar(
                centerTitle: true,
                backgroundColor: const Color(0xffF2F3F7),
                title: const Text('Detalle de reserva'),
                scrolledUnderElevation: 0.0),
            body: Padding(
                padding: const EdgeInsets.all(14),
                child: ReserveInfo(
                  reserve: reserve,
                  size: size,
                  deleteReserve: deleteReserve,
                )));
  }
}

class ReserveInfo extends StatelessWidget {
  const ReserveInfo(
      {super.key,
      required this.reserve,
      required this.size,
      required this.deleteReserve});
  final VoidCallback deleteReserve;
  final ReserveDetail reserve;
  final Size size;

  @override
  Widget build(BuildContext context) {
    const cyanColor = Color(0xff23a5cd);
    final siverPercentToDouble = double.parse(reserve.silverPercent) / 100;
    final double silverPercent =
        double.parse((siverPercentToDouble * reserve.price).toStringAsFixed(2));
    final double driverPayment = reserve.price - silverPercent;
    return kIsWeb
        ? ListView(
            children: [
              SizedBox(height: size.height * .02),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xffFFFFFF),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(23),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.width * .35,
                            child: Column(
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Datos del Servicio',
                                        style: TextStyle(
                                            color: cyanColor,
                                            fontSize: 12,
                                            fontFamily: 'Montserrat-Medium')),
                                    Divider(color: cyanColor),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      reserve.serviceType == "PERSONAL"
                                          ? MainAxisAlignment.spaceAround
                                          : MainAxisAlignment.spaceBetween,
                                  children: [
                                    BoxReserveDetail(
                                      icon: Icons.hail,
                                      label: 'Pasajero',
                                      text:
                                          '${reserve.name} ${reserve.lastName}',
                                      row: true,
                                      rowTriple: true,
                                    ),
                                    reserve.serviceType != "PERSONAL"
                                        ? BoxReserveDetail(
                                            icon: Icons.domain,
                                            label: 'Empresa',
                                            text: reserve.enterpriseName,
                                            row: true,
                                          )
                                        : const SizedBox(),
                                    BoxReserveDetail(
                                      icon: Icons.business_center_outlined,
                                      label: 'Tipo de Servicio',
                                      text: reserve.serviceType == 'ENTERPRISE'
                                          ? 'Empresarial'
                                          : 'Personal',
                                      row: true,
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * .03),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Datos del conductor y vehículo',
                                        style: TextStyle(
                                            color: cyanColor,
                                            fontFamily: 'Montserrat-Medium',
                                            fontSize: 12)),
                                    Divider(color: cyanColor),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BoxReserveDetail(
                                            icon: Icons.person_2_outlined,
                                            label: 'Conductor',
                                            text: reserve.driverName != null
                                                ? '${reserve.driverName} ${reserve.driverLastName}'
                                                : '-',
                                            row: true,
                                          ),
                                          SizedBox(width: size.width * .08),
                                          BoxReserveDetail(
                                            icon: Icons.drive_eta_rounded,
                                            label: 'Marca/ modelo/ color',
                                            text: (reserve.brand != '' &&
                                                    reserve.model != '' &&
                                                    reserve.color != '')
                                                ? '${reserve.brand}/ ${reserve.model}/ ${reserve.color}'
                                                : ' - ',
                                            row: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * .01),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    BoxReserveDetail(
                                      icon: Icons.money,
                                      label: 'Placa',
                                      text: (reserve.licensePlate != ''
                                          ? '${reserve.licensePlate}'
                                          : ' - '),
                                      row: true,
                                    ),
                                    SizedBox(width: size.width * .15),
                                    Stack(
                                      children: [
                                        ClipOval(
                                            child: reserve.driverImageUrl !=
                                                    null
                                                ? Image.network(
                                                    reserve.driverImageUrl!,
                                                    width: 75,
                                                    height: 75,
                                                  )
                                                : Image.asset(
                                                    'assets/images/driver_img_example.png')),
                                        Positioned(
                                          bottom: -10,
                                          left: -2,
                                          child: Image.asset(
                                            'assets/images/vehiculo_home_admin.png',
                                            scale: 0.9,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * .03),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BoxReservePayment(
                                        label: 'Tarifa base',
                                        text:
                                            'S/${reserve.price.toStringAsFixed(2)}'),
                                    BoxReservePayment(
                                        label: 'Pago Silver',
                                        text:
                                            'S/${silverPercent.toStringAsFixed(2)}'),
                                    BoxReservePayment(
                                        label: 'Pago conductor',
                                        text:
                                            'S/${driverPayment.toStringAsFixed(2)}'),
                                    BoxReservePayment(
                                        label: 'Porcentaje Silver',
                                        text: '${reserve.silverPercent}%'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width * .28,
                            child: Column(
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Datos Del Viaje',
                                        style: TextStyle(
                                            color: cyanColor,
                                            fontFamily: 'Montserrat-Medium',
                                            fontSize: 12)),
                                    Divider(color: cyanColor),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: BoxReserveDetail(
                                        icon: Icons.today,
                                        label: 'Fecha de Reserva',
                                        text:
                                            '${reserve.startTime.day}/${reserve.startTime.month}/${reserve.startTime.year}',
                                        row: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: BoxReserveDetail(
                                        label: 'Hora de reserva',
                                        text:
                                            '${reserve.startTime.hour}:${reserve.startTime.minute.toString().padLeft(2, '0')}',
                                        row: true,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: size.height * .03),
                                Row(
                                  children: [
                                    Expanded(
                                      child: BoxReserveDetail(
                                        icon: Icons.timeline,
                                        label: 'Tipo de viaje',
                                        text: reserve.tripType,
                                        row: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: BoxStatusReserveDetail(
                                        label: "Estado",
                                        tripStatus: reserve.tripStatus,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * .03),
                                Column(
                                  children: [
                                    BoxReserveDetail(
                                        icon: Icons.location_on,
                                        label: 'Punto de recojo',
                                        text: reserve.startAddress),
                                    SizedBox(height: size.height * .03),
                                    reserve.endAddress == null
                                        ? const SizedBox()
                                        : BoxReserveDetail(
                                            icon: Icons.trip_origin_outlined,
                                            label: 'Punto de destino',
                                            text: '${reserve.endAddress}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * .04),
              SizedBox(
                width: size.width * .3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.push('/admin/reserves/create/${reserve.id}');
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                        fixedSize: MaterialStateProperty.all(
                            Size(size.width * .15, size.height * .06)),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF03132A)),
                      ),
                      child: const Text('Editar',
                          style: TextStyle(
                            fontFamily: 'Montserrat-Bold',
                            fontSize: 16,
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(width: size.width * .02),
                    TextButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                  '¿Estás seguro de que deseas cancelar el viaje?',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center),
                              content: const Text(
                                'No podrás volver a activar el recorrido.',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-Regular',
                                    fontSize: 12),
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
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: const Text('Confirmar'),
                                  onPressed: () {
                                    deleteReserve();
                                    context.go("/admin");
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Reserva eliminada")));
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Cancelar'),
                                  onPressed: () {
                                    context.pop();
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
                                    side: const BorderSide(
                                        color: Color(0xff03132A), width: 2))),
                        fixedSize: MaterialStateProperty.all(
                            Size(size.width * .15, size.height * .06)),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0x00ffffff)),
                      ),
                      child: const Text('Cancelar',
                          style: TextStyle(
                            fontFamily: 'Montserrat-Bold',
                            fontSize: 16,
                            color: Color(0xff03132A),
                          )),
                    )
                  ],
                ),
              ),
            ],
          )
        : ListView(
            children: [
              Container(
                height: size.height,
                decoration: const BoxDecoration(
                  color: Color(0xffFFFFFF),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Datos del Servicio',
                              style: TextStyle(
                                  color: cyanColor,
                                  fontSize: 12,
                                  fontFamily: 'Montserrat-Medium')),
                          Divider(color: cyanColor),
                        ],
                      ),
                      BoxReserveDetail(
                          icon: Icons.hail,
                          label: 'Pasajero',
                          text: '${reserve.name} ${reserve.lastName}'),
                      reserve.serviceType != "PERSONAL"
                          ? BoxReserveDetail(
                              icon: Icons.domain,
                              label: 'Empresa',
                              text: reserve.enterpriseName)
                          : const SizedBox(),
                      BoxReserveDetail(
                        icon: Icons.business_center_outlined,
                        label: 'Tipo de Servicio',
                        text: reserve.serviceType == 'ENTERPRISE'
                            ? 'Empresarial'
                            : 'Personal',
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Datos Del Viaje',
                              style: TextStyle(
                                  color: cyanColor,
                                  fontFamily: 'Montserrat-Medium',
                                  fontSize: 12)),
                          Divider(color: cyanColor),
                        ],
                      ),
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
                                    '${reserve.startTime.hour}:${reserve.startTime.minute.toString().padLeft(2, '0')}'),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: BoxReserveDetail(
                                icon: Icons.timeline,
                                label: 'Tipo de viaje',
                                text: reserve.tripType),
                          ),
                          Expanded(
                            child: BoxStatusReserveDetail(
                              label: "Estado",
                              tripStatus: reserve.tripStatus,
                            ),
                          ),
                        ],
                      ),
                      BoxReserveDetail(
                          icon: Icons.location_on,
                          label: 'Punto de recojo',
                          text: reserve.startAddress),
                      reserve.endAddress == null
                          ? const SizedBox()
                          : BoxReserveDetail(
                              icon: Icons.trip_origin_outlined,
                              label: 'Punto de destino',
                              text: '${reserve.endAddress}'),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Datos del conductor y vehículo',
                              style: TextStyle(
                                  color: cyanColor,
                                  fontFamily: 'Montserrat-Medium',
                                  fontSize: 12)),
                          Divider(color: cyanColor),
                        ],
                      ),
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
                                        ? '${reserve.driverName} ${reserve.driverLastName}'
                                        : '-'),
                                BoxReserveDetail(
                                    icon: Icons.drive_eta_rounded,
                                    label: 'Marca/ modelo/ color',
                                    text: (reserve.brand != '' &&
                                            reserve.model != '' &&
                                            reserve.color != '')
                                        ? '${reserve.brand}/ ${reserve.model}/ ${reserve.color}'
                                        : ' - '),
                                BoxReserveDetail(
                                    icon: Icons.money,
                                    label: 'Placa',
                                    text: (reserve.licensePlate != ''
                                        ? '${reserve.licensePlate}'
                                        : ' - ')),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Stack(
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
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BoxReservePayment(
                              label: 'Tarifa base',
                              text: 'S/${reserve.price.toStringAsFixed(2)}'),
                          BoxReservePayment(
                              label: 'Pago Silver',
                              text: 'S/${silverPercent.toStringAsFixed(2)}'),
                          BoxReservePayment(
                              label: 'Pago conductor',
                              text: 'S/${driverPayment.toStringAsFixed(2)}'),
                          BoxReservePayment(
                              label: 'Porcentaje Silver',
                              text: '${reserve.silverPercent}%'),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              context
                                  .push('/admin/reserves/create/${reserve.id}');
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                              fixedSize: MaterialStateProperty.all(
                                  Size(size.width * .4, size.height * .06)),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF23A5CD)),
                            ),
                            child: const Text('Editar',
                                style: TextStyle(
                                  fontFamily: 'Montserrat-Bold',
                                  fontSize: 16,
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
                                        onPressed: () {
                                          deleteReserve();
                                          context.go("/admin");
                                          ScaffoldMessenger.of(context)
                                              .clearSnackBars();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Reserva eliminada")));
                                        },
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        child: const Text('Cancelar'),
                                        onPressed: () {
                                          context.pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                          color: Color(0xff23A5CD), width: 2))),
                              fixedSize: MaterialStateProperty.all(
                                  Size(size.width * .4, size.height * .06)),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0x00ffffff)),
                            ),
                            child: const Text('Cancelar',
                                style: TextStyle(
                                  fontFamily: 'Montserrat-Bold',
                                  fontSize: 16,
                                  color: Color(0xff23A5CD),
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
