import 'package:flutter/material.dart';

class LabelExtraTripEnd extends StatelessWidget {
  final String text;
  const LabelExtraTripEnd({super.key, required this.text});

  final styleText = const TextStyle(
    color: Color(0xFF1D192B),
    fontFamily: "Montserrat-Medium",
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: size.height * .02),
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
              maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }
}
