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
        body: Padding(
            padding: const EdgeInsets.all(12),
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
            text: "${reserve.name.toString()} ${reserve.lastName.toString()}"),
        BoxReserveDetail(
          icon: Icons.domain,
          label: "Empresa",
          text: reserve.entrepriseName.toString(),
        ),
        BoxReserveDetail(
            icon: Icons.propane_tank_outlined,
            label: "Tipo de servicio",
            text: reserve.serviceType.toString()),
        const TitleReserveDetail(text: "Datos del viaje"),
        Row(
          children: [
            Expanded(
              child: BoxReserveDetail(
                icon: Icons.today,
                label: "Fecha de reserva",
                text:
                    '${reserve.startTime.day}/${reserve.startTime.month}/${reserve.startTime.year}',
              ),
            ),
            Expanded(
              child: BoxReserveDetail(
                icon: Icons.alarm,
                label: "Hora de reserva",
                text: '${reserve.startTime.hour}:${reserve.startTime.minute}',
              ),
            ),
          ],
        ),
        Row(children: [
          Expanded(
            child: BoxReserveDetail(
              icon: Icons.timeline,
              label: "Tipo de viaje",
              text: reserve.tripType,
            ),
          ),
          const Expanded(
            child: BoxEstadoReserveDetail(
              icon: Icons.cached,
              label: "Estado",
              estado: true,
            ),
          )
        ]),
        BoxReserveDetail(
          icon: Icons.location_on,
          label: "Punto de origen",
          text: reserve.startAddress.toString(),
        ),
        Container(
          width: 2.0, // Ancho de la línea
          height: 29.0, // Altura de la línea vertical
          color: Colors.black,
          padding: const EdgeInsets.all(2.0), // Color de la línea
        ),
        BoxReserveDetail(
          icon: Icons.trip_origin,
          label: "Punto de destino",
          text: reserve.endAddress.toString(),
        ),
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
                  style: TextStyle(fontFamily: "Raleway", fontSize: 20.0)),
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
