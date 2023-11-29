import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_detail.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_reserve_detail_provider.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_state_reserve_detail.dart';
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
      return Scaffold(
          backgroundColor: Colors.grey[200],
          body: const Center(
            child: CircularProgressIndicator(),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFFF2F3F7),
        title: const Text('Detalles'),
        centerTitle: true,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.67,
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(5),
          child: ReserveInfo(reserve: reserve)),
      backgroundColor: const Color(0xffF2F3F7),
    );
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
    String capitalizeFirst(String input) {
      return input[0].toUpperCase() + input.substring(1).toLowerCase();
    }

    double driverIncome(price, silverPercent) {
      return price - ((price / 100) * silverPercent);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const TitleReserveDetail(text: 'Datos del servicio'),
        const SizedBox(
          height: 10,
        ),
        BoxReserveDetail(
            icon: Icons.hail,
            label: "Pasajero",
            text: "${reserve.name} ${reserve.lastName}",
            row: false),
        const SizedBox(height: 8),
        BoxReserveDetail(
            icon: Icons.domain,
            label: "Empresa",
            text: reserve.enterpriseName ?? "Personal",
            row: false),
        const SizedBox(height: 8),
        BoxReserveDetail(
            icon: Icons.business_center_outlined,
            label: "Tipo de servicio",
            text: capitalizeFirst(reserve.serviceType),
            row: false),
        const SizedBox(height: 5),
        const TitleReserveDetail(text: "Datos del viaje"),
        const SizedBox(
          height: 10,
        ),
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
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: BoxReserveDetail(
                icon: Icons.timeline,
                label: "Tipo de viaje",
                text: capitalizeFirst(reserve.tripType),
                row: true),
          ),
          Expanded(
            child: BoxStateReserveDetail(
              icon: Icons.cached,
              label: "Estado",
              state: reserve.state,
            ),
          )
        ]),
        const SizedBox(height: 8),
        BoxReserveDetail(
            icon: Icons.location_on_outlined,
            label: "Punto de origen",
            text: reserve.startAddress,
            row: false),
        reserve.endAddress != null
            ? Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 11.0,
                      ),
                      Container(
                        width: 2.0,
                        height: 25.0,
                        color: Colors.black,
                        padding: const EdgeInsets.all(2.0),
                      ),
                    ],
                  ),
                  BoxReserveDetail(
                      icon: Icons.trip_origin,
                      label: "Punto de destino",
                      text: reserve.endAddress!,
                      row: false),
                ],
              )
            : const SizedBox(),
        Container(
          height: 40.0,
        ),
        Row(children: [
          const Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tarifa \nconductor",
                  style: TextStyle(
                      height: 1.2, fontSize: 20.0, color: Color(0xff03132A))),
            ],
          )),
          Expanded(
              child: Text(
                  "S/  ${driverIncome(reserve.price, reserve.silverPercent).toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 32.0,
                    color: Color(0xff03132A),
                  ))),
        ])
      ]),
    );
  }
}
