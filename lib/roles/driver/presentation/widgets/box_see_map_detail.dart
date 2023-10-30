import 'package:flutter/material.dart';

class SeeMap extends StatefulWidget {
  const SeeMap({super.key});

  @override
  State<SeeMap> createState() => _SeeMapState();
}

class _SeeMapState extends State<SeeMap> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Icon(
          Icons.map,
          color: Color(0xFF23A5CD),
        ),
        Text("Ver mapa",
            style: TextStyle(
              color: Color(0xFF23A5CD),
              decoration: TextDecoration.underline,
              fontFamily: "Monserrat",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ))
      ]),
    );
  }
}
