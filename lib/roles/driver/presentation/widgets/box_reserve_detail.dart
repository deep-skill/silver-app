import 'package:flutter/material.dart';

class BoxReserveDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;
  final bool row;

  const BoxReserveDetail({
    super.key,
    required this.icon,
    required this.label,
    required this.text,
    required this.row,
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
          width: MediaQuery.of(context).size.width * (row ? .35 : .70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                style: const TextStyle(
                  color: Color(0xFF23A5CD),
                  fontFamily: "Monserrat",
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(text,
                  maxLines: 3,
                  style: const TextStyle(
                    fontFamily: "Monserrat",
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  )),
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
//maxLines: 1,
/*                               overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ), */