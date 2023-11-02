import 'package:flutter/material.dart';

class BoxEstadoReserveDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String estado;

  const BoxEstadoReserveDetail({
    super.key,
    required this.icon,
    required this.label,
    required this.estado,
  });

  Color color() {
    switch (estado) {
      case 'COMPLETED':
        return const Color(0xFF2FCF5C);
      case 'CANCELED':
        return const Color(0xFFFD3B3B);
      default:
        return const Color(0xFF23A5CD);
    }
  }

  String textState() {
    switch (estado) {
      case 'COMPLETED':
        return 'Finalizado';
      case 'CANCELED':
        return 'Cancelado';
      default:
        return 'En progreso';
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
                textState(),
                style: TextStyle(
                  color: color(),
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
