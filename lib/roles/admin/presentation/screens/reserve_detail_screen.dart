import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_detail.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_detail_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_list_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/alert_dialogs/build_delete_dialog.dart';
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

    return kIsWeb
        ? Scaffold(
            backgroundColor: const Color(0xffF2F3F7),
            appBar: AppBar(
                backgroundColor: const Color(0xffF2F3F7),
                title: const Text('Detalle de reserva'),
                scrolledUnderElevation: 0.0),
            body: Padding(
                padding: const EdgeInsets.fromLTRB(180, 20, 180, 20),
                child: ReserveInfo(reserve: reserve, size: size, ref: ref)))
        : Scaffold(
            backgroundColor: const Color(0xffF2F3F7),
            appBar: AppBar(
                centerTitle: true,
                backgroundColor: const Color(0xffF2F3F7),
                title: const Text('Detalle de reserva'),
                scrolledUnderElevation: 0.0),
            body: Padding(
                padding: const EdgeInsets.all(14),
                child: ReserveInfo(reserve: reserve, size: size, ref: ref)));
  }
}

class ReserveInfo extends StatelessWidget {
  const ReserveInfo(
      {super.key,
      required this.reserve,
      required this.size,
      required this.ref});
  final ReserveDetail reserve;
  final Size size;

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    const cyanColor = Color(0xff23a5cd);
    final siverPercentToDouble = double.parse(reserve.silverPercent) / 100;
    final priceToDouble = double.parse(reserve.price);
    final double silverPercent =
        double.parse((siverPercentToDouble * priceToDouble).toStringAsFixed(2));
    final double driverPayment = priceToDouble - silverPercent;
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
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BoxReserveDetail(
                                        icon: Icons.hail,
                                        label: 'Pasajero',
                                        text:
                                            '${reserve.name} ${reserve.lastName}'),
                                    BoxReserveDetail(
                                        icon: Icons.domain,
                                        label: 'Empresa',
                                        text: reserve.enterpriseName),
                                    BoxReserveDetail(
                                        icon: Icons.business_center_outlined,
                                        label: 'Tipo de Servicio',
                                        text: reserve.serviceType),
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
                                                  : '-'),
                                          SizedBox(width: size.width * .08),
                                          BoxReserveDetail(
                                              icon: Icons.drive_eta_rounded,
                                              label: 'Marca/ modelo/ color',
                                              text: (reserve.brand != '' &&
                                                      reserve.model != '' &&
                                                      reserve.color != '')
                                                  ? '${reserve.brand}/ ${reserve.model}/ ${reserve.color}'
                                                  : ' - '),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * .03),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    BoxReserveDetail(
                                        icon: Icons.money,
                                        label: 'Placa',
                                        text: (reserve.licensePlate != ''
                                            ? '${reserve.licensePlate}'
                                            : ' - ')),
                                    SizedBox(width: size.width * .15),
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          ClipOval(
                                              child: Image.asset(
                                            'assets/images/driver_img_example.png',
                                            scale: 0.7,
                                          )),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            child: Image.asset(
                                              'assets/images/vehiculo_home_admin.png',
                                              scale: 0.9,
                                            ),
                                          ),
                                        ],
                                      ),
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
                                        text: 'S/${reserve.price}'),
                                    BoxReservePayment(
                                        label: 'Pago Silver',
                                        text: 'S/$silverPercent'),
                                    BoxReservePayment(
                                        label: 'Pago conductor',
                                        text: 'S/$driverPayment'),
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
                                SizedBox(height: size.height * .03),
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
                                SizedBox(height: size.height * .03),
                                Column(
                                  children: [
                                    BoxReserveDetail(
                                        icon: Icons.location_on,
                                        label: 'Punto de recojo',
                                        text: reserve.startAddress),
                                    SizedBox(height: size.height * .03),
                                    BoxReserveDetail(
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
                                  '¿Estás seguro de que deseas cancelar la reserva?',
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
                                  onPressed: () async {
                                    await deleteReserve(reserve.toString());
                                  },
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
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
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
                      BoxReserveDetail(
                          icon: Icons.domain,
                          label: 'Empresa',
                          text: reserve.enterpriseName),
                      BoxReserveDetail(
                          icon: Icons.business_center_outlined,
                          label: 'Tipo de Servicio',
                          text: reserve.serviceType),
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
                      BoxReserveDetail(
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
                              label: 'Tarifa base', text: 'S/${reserve.price}'),
                          BoxReservePayment(
                              label: 'Pago Silver', text: 'S/$silverPercent'),
                          BoxReservePayment(
                              label: 'Pago conductor',
                              text: 'S/$driverPayment'),
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
                            onPressed: () async {
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
                                        '¿Estás seguro de que deseas cancelar la reserva?',
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
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return buildDeleteDialog(context);
                                            },
                                          );

                                          final res = await deleteReserve(
                                              reserve.id.toString());

                                          void showSuccessDialog() {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return WillPopScope(
                                                  onWillPop: () async {
                                                    return false;
                                                  },
                                                  child: AlertDialog(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 20,
                                                            vertical: 20),
                                                    content: SizedBox(
                                                      width: size.width * 0.7,
                                                      height: size.height * 0.1,
                                                      child: const Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(Icons.check,
                                                              size: 40,
                                                              color:
                                                                  Colors.green),
                                                          SizedBox(height: 8),
                                                          Text(
                                                            'Reserva eliminada',
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          ref
                                                              .read(
                                                                  reservesListProvider
                                                                      .notifier)
                                                              .reloadData();
                                                          context.pop();
                                                          context.pop();
                                                          context.pop();
                                                        },
                                                        child: const Text(
                                                            'Cerrar'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }

                                          void showErrorDialog() {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return WillPopScope(
                                                  onWillPop: () async {
                                                    return false;
                                                  },
                                                  child: AlertDialog(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 20,
                                                            vertical: 20),
                                                    content: SizedBox(
                                                      width: size.width * 0.7,
                                                      height: size.height * 0.1,
                                                      child: Column(
                                                        children: [
                                                          Icon(Icons.error,
                                                              size: size.width *
                                                                  .08,
                                                              color:
                                                                  Colors.red),
                                                          SizedBox(
                                                            height: 1,
                                                          ),
                                                          Text(
                                                            'Error al internar eliminar la reserva.',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    size.width *
                                                                        .04),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          context.pop();
                                                          context.pop();
                                                        },
                                                        child: const Text(
                                                            'Cerrar'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }

                                          if (res == 204) {
                                            showSuccessDialog();
                                          } else {
                                            showErrorDialog();
                                          }
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
                                          Navigator.of(context).pop();
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
