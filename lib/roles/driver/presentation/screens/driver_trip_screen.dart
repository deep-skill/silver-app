import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/presentation/widgets/alertDialog/alert_trip_canceled.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_additional_information.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_see_map_detail.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_trip_status.dart';
import 'package:silverapp/roles/driver/presentation/widgets/box_trip_status_text.dart';
import 'package:silverapp/roles/driver/presentation/widgets/buttons/button_driver.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_screen/address_info.dart';
import 'package:silverapp/roles/driver/presentation/widgets/title_reserve.dart';

class TripsDriver extends StatefulWidget {
  const TripsDriver({super.key});

  @override
  State<TripsDriver> createState() => _TripsDriverState();
}

class _TripsDriverState extends State<TripsDriver> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: const [
      SeeMap(),
      AddressInfoWidget(originAddress: "gola", destinationAddress: "gola"),
      // ignore: prefer_const_constructors
      TripStatus(status: "PointOfOrigin"),
      TripStatusText(),
      TripButton(buttonText: "hola", alertWidget: AlertTripCanceled()),
      SizedBox(
        height: 10,
      ),

      SizedBox(
        height: 10,
      ),
      TitleReserve(text: "Informacion adicional"),
      SizedBox(
        height: 5,
      ),
      AdditionalInformacion(boolValue: true)
    ]);
  }
}
