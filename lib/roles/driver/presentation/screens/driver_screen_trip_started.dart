import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_end_trip.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_additional_information.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_reserve_detail.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_see_map_detail.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_trip_status.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_trip_status_text.dart';
import 'package:silverapp/roles/driver/presentation/widgets/title_reserve.dart';

class ScreenTripStarted extends StatelessWidget {
  const ScreenTripStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(5),
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: const TripStarted()));
  }
}

class TripStarted extends StatelessWidget {
  const TripStarted({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const SeeMap(),
      const BoxReserveDetail(
          icon: Icons.location_on_outlined,
          label: "Punto de origen",
          text: "Mz. 1A, Lote 1, Av. Defensores del Morro, Cercado de Lima",
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
      const BoxReserveDetail(
          icon: Icons.trip_origin,
          label: "Punto de destino",
          text: " Av San Juan 1501, San Juan de Miraflores 15803",
          row: false),
      // ignore: prefer_const_constructors
      TripStatus(status: "JourneyStarted"),
      const TripStatusText(),

      const SizedBox(
        height: 10,
      ),
      const TitleReserve(text: "Informacion adicional"),
      const SizedBox(
        height: 5,
      ),
      const AdditionalInformacion(boolValue: true),
      ElevatedButton(
          onPressed: () => {
                showDialog(
                    context: context,
                    builder: (context) => const AlertTripEnd())
              },
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(10)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
          child: const Text("Finalizar viaje",
              style: TextStyle(
                fontFamily: "Monserrat",
                fontSize: 16,
                color: Colors.white,
              ))),
    ]);
  }
}
