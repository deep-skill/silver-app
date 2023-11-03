import 'package:flutter/material.dart';

class BoxReserveDetail extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String text;

  const BoxReserveDetail({
    super.key,
    this.icon,
    required this.label,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon != null
            ? Icon(
                icon,
              )
            : Text(''),
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
              ),
              Text(text,
                  maxLines: 2,
                  style: const TextStyle(
                    fontFamily: "Monserrat",
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  )),
              Container(
                height: 0.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
