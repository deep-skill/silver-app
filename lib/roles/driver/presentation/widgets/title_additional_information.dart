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
        color: Colors.cyan,
      ),
      const SizedBox(
        width: 8.0,
      ),
      Text(
        label,
        style: const TextStyle(
            color: Colors.cyan,
            fontFamily: "Monserrat",
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
    ]);
  }
}
