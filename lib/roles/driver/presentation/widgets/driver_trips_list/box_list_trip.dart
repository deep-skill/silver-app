import 'package:flutter/material.dart';

class BoxTripList extends StatelessWidget {
  final String image;
  final String name;
  final String date;
  final String stateReserve;

  const BoxTripList({
    Key? key,
    required this.stateReserve,
    required this.image,
    required this.name,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_declarations
    final TextStyle styleName =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
    const TextStyle styleText =
        // ignore: prefer_const_constructors
        TextStyle(fontWeight: FontWeight.normal, fontSize: 10);

    const TextStyle styleTextPay =
        // ignore: prefer_const_constructors
        TextStyle(fontWeight: FontWeight.bold, fontSize: 10);

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
            child: Image.network(
              image,
              width: MediaQuery.of(context).size.width * 0.2,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
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
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                        Text(" S/. 100.00", style: styleTextPay),
                      ]),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      Text("Finalizado",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.green[300])),
                    ],
                  )
                ]),
          ),
          IconButton(
              onPressed: () => print("Pressed"),
              icon: const Icon(Icons.navigate_next))
        ],
      ),
    );
  }
}
