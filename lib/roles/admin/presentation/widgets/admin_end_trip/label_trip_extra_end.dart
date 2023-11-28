import 'package:flutter/material.dart';

class LabelExtraTripEnd extends StatelessWidget {
  final String text;
  const LabelExtraTripEnd({super.key, required this.text});

  final styleText = const TextStyle(
    color: Color(0xFF000000),
    fontFamily: "Monserrat",
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.bottomStart,
      child: Row(
        children: [
          const SizedBox(
            width: 32,
          ),
          Text(
            text,
            style: styleText,
          ),
        ],
      ),
    );
  }
}
