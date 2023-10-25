import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class BoxEstadoReserveDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool estado;
  final String textFinal = "Finalizado";
  final String textPendiente = "Pendiente";

  const BoxEstadoReserveDetail({
    super.key,
    required this.icon,
    required this.label,
    required this.estado,
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
            AutoSizeText(
              estado ? textFinal : textPendiente,
              style: TextStyle(
                color: estado ? Colors.green : Colors.red,
                fontFamily: "Monserrat",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              group: AutoSizeGroup(),
            ),
            Container(
              height: 2.0,
            ),
          ],
        ),
      ],
    );
  }
}
