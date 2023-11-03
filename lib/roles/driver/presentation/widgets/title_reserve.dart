import 'package:flutter/material.dart';

class TitleReserve extends StatelessWidget {
  final String text;

  const TitleReserve({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF23A5CD),
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
          color: const Color(0xFF23A5CD),
        ),
      ],
    );
  }
}
