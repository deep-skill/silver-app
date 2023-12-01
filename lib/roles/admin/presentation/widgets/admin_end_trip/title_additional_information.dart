import 'package:flutter/material.dart';

class TitleAdditionalInformation extends StatelessWidget {
  final IconData icon;
  final String label;

  const TitleAdditionalInformation({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        icon,
        color: const Color(0xFF23A5CD),
      ),
      const SizedBox(
        width: 8.0,
      ),
      Text(
        label,
        style: const TextStyle(
          color: Color(0xFF23A5CD),
          fontFamily: "Montserrat-Semi-Bold",
          fontSize: 16,
        ),
      ),
    ]);
  }
}
