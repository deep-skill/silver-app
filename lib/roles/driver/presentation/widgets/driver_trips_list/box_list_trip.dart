import 'package:flutter/material.dart';

class BoxTripList extends StatelessWidget {
  final String image;
  final String name;
  final String date;
  final String stateTrip;
  final double totalPriceDriver;
  final int tripId;

  const BoxTripList({
    Key? key,
    required this.stateTrip,
    required this.image,
    required this.name,
    required this.date,
    required this.totalPriceDriver,
    required this.tripId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle styleName =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
    const TextStyle styleText =
        TextStyle(fontWeight: FontWeight.normal, fontSize: 10);
    const TextStyle styleTextPay =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 10);

    String textState() {
      if (stateTrip == "CANCELED") {
        return "Cancelada";
      } else if (stateTrip == "COMPLETED") {
        return "Finalizado";
      } else {
        return "En progreso";
      }
    }

    Color? colorState() {
      if (stateTrip == "CANCELED") {
        return Colors.red[300];
      } else if (stateTrip == "COMPLETED") {
        return Colors.green[300];
      } else {
        return Colors.blue[300];
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              image,
              width: MediaQuery.of(context).size.width * 0.2,
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
                        name,
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
                        date.toString(),
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
                              "Tarifa total",
                              style: styleTextPay,
                            ),
                          ],
                        ),
                        Text(" S/. ${totalPriceDriver.toStringAsFixed(2)}",
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
              onPressed: () => print(tripId),
              icon: const Icon(Icons.navigate_next))
        ],
      ),
    );
  }
}
