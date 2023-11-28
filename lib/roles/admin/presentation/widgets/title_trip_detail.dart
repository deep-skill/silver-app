import 'package:flutter/material.dart';

class TitleTripDetail extends StatelessWidget {
  final String text;

  const TitleTripDetail({super.key, required this.text});

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
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
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