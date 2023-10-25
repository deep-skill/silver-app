import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class BoxReserveDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;

  const BoxReserveDetail({
    super.key,
    required this.icon,
    required this.label,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon, // Color azul para el icono
        ),
        const SizedBox(width: 8.0), // Espacio entre el icono y el label
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              label,
              style: const TextStyle(
                color: Color(0xFF23A5CD),
                fontFamily: "Monserrat",
                fontSize: 12,
                fontWeight: FontWeight.bold, // Color azul para el label
              ),
            ),
            AutoSizeText(text,
                group: AutoSizeGroup(),
                style: const TextStyle(
                  fontFamily: "Monserrat",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                )),
            Container(
              height: 2.0,
            ),
          ],
        ),
      ],
    );
  }
}
