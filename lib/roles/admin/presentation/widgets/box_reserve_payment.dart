import 'package:flutter/material.dart';

class BoxReservePayment extends StatelessWidget {
  final String label;
  final String text;
  const BoxReservePayment({super.key, required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .20,
          child: Column(
            children: [
              Text(
                label,
                maxLines: 2,
                style: TextStyle(
                  fontWeight: FontWeight.w400, // Peso de fuente 400
                  fontSize: 12, // Tamaño de fuente 12px
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w700, // Peso de fuente 700
                  fontSize: 16, // Tamaño de fuente 16px
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 2.0,
          height: 50.0,
          color: Colors.black,
          // padding: const EdgeInsets.all(2.0),
        ),
      ],
    );
  }
}
