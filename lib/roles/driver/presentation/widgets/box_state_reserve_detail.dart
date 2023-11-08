import 'package:flutter/material.dart';

class BoxStateReserveDetail extends StatelessWidget {
  final IconData icon;
  final String label;

  final String? state;

  const BoxStateReserveDetail({
    super.key,
    required this.icon,
    required this.label,
    required this.state,
  });

  Color color() {
    switch (state) {
      case 'COMPLETED':
        return const Color(0xFF2FCF5C);
      case 'CANCELED':
        return const Color(0xFFFD3B3B);
      case "IN_PROGRESS":
        return const Color(0xFF23A5CD);
      default:
        return const Color.fromARGB(255, 12, 12, 12);
    }
  }

  String textState() {
    switch (state) {
      case 'COMPLETED':
        return 'Finalizado';
      case 'CANCELED':
        return 'Cancelado';
      case "IN_PROGRESS":
        return 'En progreso';
      default:
        return "----";
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
                overflow: TextOverflow.ellipsis,
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
                overflow: TextOverflow.ellipsis,
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
