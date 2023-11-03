import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_detail.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_reserve_detail_provider.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_estado_reserve_detail.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_reserve_detail.dart';
import 'package:silverapp/roles/driver/presentation/widgets/title_reserve_detail.dart';

class DriverReserveDetailScreen extends ConsumerStatefulWidget {
  const DriverReserveDetailScreen({super.key, required this.reserveId});

  final String reserveId;

  @override
  ReserveDetailScreenState createState() => ReserveDetailScreenState();
}

class ReserveDetailScreenState
    extends ConsumerState<DriverReserveDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref
        .read(driverReserveDetailProvider.notifier)
        .loadReserveDetail(widget.reserveId);
  }

  @override
  Widget build(BuildContext context) {
    final reserves = ref.watch(driverReserveDetailProvider);
    final DriverReserveDetail? reserve = reserves[widget.reserveId];
    if (reserve == null) {
      return const Scaffold(
          backgroundColor: Colors.grey,
          body: Center(
            child: CircularProgressIndicator(),
          ));
    }

    return Scaffold(
        appBar: AppBar(title: const Text('Detalles')),
        body: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 231, 230, 230),
            ),
            padding: const EdgeInsets.all(3),
            child: ReserveInfo(reserve: reserve)));
  }
}

class ReserveInfo extends StatelessWidget {
  const ReserveInfo({
    super.key,
    required this.reserve,
  });
  final DriverReserveDetail reserve;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const TitleReserveDetail(text: "Datos del servicio"),
        BoxReserveDetail(
            icon: Icons.hail,
            label: "Pasajero",
            text: "${reserve.name.toString()} ${reserve.lastName.toString()}",
            row: false),
        BoxReserveDetail(
            icon: Icons.domain,
            label: "Empresa",
            text: reserve.entrepriseName.toString(),
            row: false),
        BoxReserveDetail(
            icon: Icons.business_center_outlined,
            label: "Tipo de servicio",
            text: reserve.serviceType.toString(),
            row: false),
        const TitleReserveDetail(text: "Datos del viaje"),
        Row(
          children: [
            Expanded(
              child: BoxReserveDetail(
                  icon: Icons.today,
                  label: "Fecha de reserva",
                  text:
                      '${reserve.startTime.day}/${reserve.startTime.month}/${reserve.startTime.year}',
                  row: true),
            ),
            Expanded(
              child: BoxReserveDetail(
                  icon: Icons.alarm,
                  label: "Hora de reserva",
                  text: '${reserve.startTime.hour}:${reserve.startTime.minute}',
                  row: true),
            ),
          ],
        ),
        Row(children: [
          Expanded(
            child: BoxReserveDetail(
                icon: Icons.timeline,
                label: "Tipo de viaje",
                text: reserve.tripType,
                row: true),
          ),
          const Expanded(
            child: BoxEstadoReserveDetail(
              icon: Icons.cached,
              label: "Estado",

              estado: "COMPLETED",

            ),
          )
        ]),
        BoxReserveDetail(
            icon: Icons.location_on_outlined,
            label: "Punto de origen",
            text: reserve.startAddress.toString(),
            row: false),
        Row(
          children: [
            Container(
              width: 11.0,
            ),
            Container(
              width: 2.0,
              height: 29.0,
              color: Colors.black,
              padding: const EdgeInsets.all(2.0),
            ),
          ],
        ),
        BoxReserveDetail(
            icon: Icons.trip_origin,
            label: "Punto de destino",
            text: reserve.endAddress.toString(),
            row: false),
        Container(
          height: 10.0,
        ),
        Row(children: [
          const Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tarifa",
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )),
              Text("conductor",
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          )),
          Expanded(
              child: Text("S/  ${reserve.price.toString()}",
                  style: const TextStyle(
                    fontFamily: "Raleway",
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ))),
        ])
      ]),
    );
  }
}
