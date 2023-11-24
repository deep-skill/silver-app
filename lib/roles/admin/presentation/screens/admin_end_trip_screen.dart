import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_end_detail.dart';
import 'package:silverapp/roles/admin/presentation/providers/trip_detail_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/box_estado_reserve_detail.dart';
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

    String capitalizeFirst(String input) {
      return input[0].toUpperCase() + input.substring(1).toLowerCase();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalles'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(7.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const TitleTripDetail(text: "Datos del servicio"),
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
                  const TitleTripDetail(text: "Datos del viaje"),
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
                      Expanded(
                        child: BoxEstadoReserveDetail(
                            tripStatus: trip.status, label: "Estado"),
                      ),
                    ],
                  ),
                ],
              )),
        ));
  }
}
