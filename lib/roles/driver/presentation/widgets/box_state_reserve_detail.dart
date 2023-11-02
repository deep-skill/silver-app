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

/*   values: ['COMPLETED', 'CANCELED', 'INPROGRESS'],
      defaultValue: 'INPROGRESS' */

  String getState(String estado) {
    switch (estado) {
      case 'COMPLETED':
        return 'Finalizado';
      case 'CANCELED':
        return 'Cancelado';
      default:
        return 'En progreso';
    }
  }

  Object getColor(String estado) {
    switch (estado) {
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELED':
        return Colors.red;
      default:
        return Colors.cyan;
    }
  }

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
                getState(estado.toString()),
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
