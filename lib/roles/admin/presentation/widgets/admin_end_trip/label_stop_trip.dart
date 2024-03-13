import 'package:flutter/material.dart';

class LabelStopTripEnd extends StatelessWidget {
  final String text;
  const LabelStopTripEnd({super.key, required this.text});

  final styleText = const TextStyle(
    color: Color(0xFF000000),
    fontFamily: "Monserrat",
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
      ),
      alignment: AlignmentDirectional.bottomStart,
      child: Row(
        children: [
          const SizedBox(
            width: 32,
          ),
          Expanded(
            child: Text(
              text,
              style: styleText,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
