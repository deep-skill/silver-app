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
          size: MediaQuery.of(context).size.width * 0.055,
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
                  fontFamily: "Montserrat-Medium",
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(text,
                  maxLines: 3,
                  style: const TextStyle(
                    fontFamily: "Montserrat-Medium",
                    fontSize: 16,
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
