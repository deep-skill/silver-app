import 'package:flutter/material.dart';

class TitleReserveDetail extends StatelessWidget {
  final String text;

  const TitleReserveDetail({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF23A5CD),
            fontFamily: "Montserrat-Medium",
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Container(
          height: 1.0,
          color: const Color(0xFF23A5CD),
        ),
      ],
    );
  }
}
