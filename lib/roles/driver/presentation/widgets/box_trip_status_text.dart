import 'package:flutter/material.dart';

class TripStatusText extends StatelessWidget {
  const TripStatusText({super.key});

  final TextStyle styleText = const TextStyle(
    fontFamily: "Monserrat",
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Text(
                  "En Camino",
                  style: styleText,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Text(
                  "En el punto de origen",
                  style: styleText,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(
                "Viaje iniciado",
                style: styleText,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(
                "Viaje finalizado",
                style: styleText,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ));
  }
}
