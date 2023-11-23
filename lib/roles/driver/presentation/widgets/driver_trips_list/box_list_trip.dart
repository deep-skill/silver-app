import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_list.dart';

class BoxTripList extends StatelessWidget {
  final DriverTripList trip;

  const BoxTripList({
    Key? key,
    required this.trip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle styleName =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
    const TextStyle styleText =
        TextStyle(fontWeight: FontWeight.normal, fontSize: 10);
    const TextStyle styleTextPay =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    TextStyle styleTextImage = const TextStyle(
        fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white);

    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dec'
    ];

    String getDate() {
      final mont = months[trip.onWayDriver.month - 1];

      return "${trip.onWayDriver.day} $mont ${trip.onWayDriver.year} | ${trip.onWayDriver.hour}:${trip.onWayDriver.minute}";
    }

    double calculateDriverPrice() {
      double result =
          trip.totalPrice - (trip.totalPrice * trip.silverPercent / 100);
      for (var element in trip.tolls) {
        result += element.amount;
      }
      for (var element in trip.parkings) {
        result += element.amount;
      }
      return result;
    }

    String textState() {
      if (trip.status == "CANCELED") {
        return "Cancelada";
      } else if (trip.status == "COMPLETED") {
        return "Finalizado";
      } else {
        return "En progreso";
      }
    }

    Color colorState() {
      if (trip.status == "CANCELED") {
        return const Color(0xFFFD3B3B);
      } else if (trip.status == "COMPLETED") {
        return const Color(0xFF2FCF5C);
      } else {
        return const Color(0xFF23A5CD);
      }
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
            spreadRadius: 1.0,
            offset: Offset(3, 2),
          ),
        ],
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(2),
      alignment: Alignment.center,
      margin: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * 0.7,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 4,
          ),
          Container(
            width: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/images/enterprise_logo.png",
                  width: 100.0,
                ),
                Text(
                  trip.enterpriseName,
                  style: styleTextImage,
                )
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 6,
                      ),
                      const Icon(
                        Icons.hail,
                        size: 17.0,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        "${trip.name} ${trip.lastName}",
                        style: styleName,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 6,
                      ),
                      const Icon(
                        Icons.date_range_outlined,
                        size: 17.0,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        getDate(),
                        style: styleText,
                      ),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Pago conductor",
                              style: styleTextPay,
                            ),
                          ],
                        ),
                        Text(
                            " S/. ${calculateDriverPrice().toStringAsFixed(2)}",
                            style: styleTextPay),
                      ]),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      Text(textState(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: colorState())),
                    ],
                  )
                ]),
          ),
          IconButton(
              onPressed: () => print(trip.id),
              icon: const Icon(Icons.navigate_next))
        ],
      ),
    );
  }
}
