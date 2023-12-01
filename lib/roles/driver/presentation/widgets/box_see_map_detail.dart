import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SeeMap extends StatelessWidget {
  const SeeMap({
    super.key,
    required this.arrivedDriver,
    required this.startTime,
    required this.endTime,
    required this.startAddress,
    required this.startAddressLat,
    required this.startAddressLon,
    this.endAddress,
    this.endAddressLat,
    this.endAddressLon,
  });
  final DateTime? arrivedDriver;
  final DateTime? startTime;
  final DateTime? endTime;
  final String startAddress;
  final double startAddressLat;
  final double startAddressLon;
  final String? endAddress;
  final double? endAddressLat;
  final double? endAddressLon;

  @override
  Widget build(BuildContext context) {
    launchWaze(String url) async {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        return false;
      }
    }

    return SizedBox(
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        ElevatedButton(
            child: const Row(children: [
              Icon(
                Icons.map,
                color: Color(0xFF23A5CD),
              ),
              Text("Ver mapa",
                  style: TextStyle(
                    color: Color(0xFF23A5CD),
                    decoration: TextDecoration.underline,
                    fontFamily: "Montserrat-Bold",
                    fontSize: 16,
                  ))
            ]),
            onPressed: () {
              if (arrivedDriver == null) {
                launchWaze(
                    "https://waze.com/ul?ll=${startAddressLat.toString()},${startAddressLon.toString()}&navigate=yes");
              }
              if (arrivedDriver != null &&
                  startTime != null &&
                  endAddress != null) {
                launchWaze(
                    "https://waze.com/ul?ll=${endAddressLat.toString()},${endAddressLon.toString()}&navigate=yes");
              }
            }),
      ]),
    );
  }
}
