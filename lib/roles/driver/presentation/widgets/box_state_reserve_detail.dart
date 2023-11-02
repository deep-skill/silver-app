import 'package:flutter/material.dart';

class BoxStateReserveDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool estado;
  final String textFinal = "Finalizado";
  final String textPendiente = "Pendiente";

  const BoxStateReserveDetail({
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
          icon,
        ),
        const SizedBox(width: 8.0),
        SizedBox(
          width: MediaQuery.of(context).size.width * .35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF23A5CD),
                  fontFamily: "Monserrat",
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow
                    .ellipsis, // Muestra "..." cuando el texto se desborda
                maxLines: 1,
              ),
              Text(
                estado ? textFinal : textPendiente,
                style: TextStyle(
                  color: estado ? Colors.green : Colors.red,
                  fontFamily: "Monserrat",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow
                    .ellipsis, // Muestra "..." cuando el texto se desborda
                maxLines: 1,
              ),
              Container(
                height: 2.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
