import 'package:flutter/material.dart';

class TripStatus extends StatelessWidget {
  final DateTime? arrivedDriver;
  final DateTime? startTime;
  final DateTime? endTime;

  const TripStatus({
    super.key,
    required this.arrivedDriver,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.radio_button_checked,
            size: 20.0,
            color: Colors.green,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .18,
            height: 2.0,
            color: (arrivedDriver != null) ? Colors.green : Colors.grey,
            padding: const EdgeInsets.all(2.0),
          ),
          Icon(
            (arrivedDriver != null)
                ? Icons.radio_button_checked
                : Icons.trip_origin,
            size: 20.0,
            color: (arrivedDriver != null) ? Colors.green : Colors.grey,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .18,
            height: 2.0,
            color: (startTime != null) ? Colors.green : Colors.grey,
            padding: const EdgeInsets.all(2.0),
          ),
          Icon(
            (startTime != null)
                ? Icons.radio_button_checked
                : Icons.trip_origin,
            size: 20.0,
            color: (startTime != null) ? Colors.green : Colors.grey,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .18,
            height: 2.0,
            color: (endTime != null) ? Colors.green : Colors.grey,
            padding: const EdgeInsets.all(2.0),
          ),
          Icon(
            (endTime != null) ? Icons.radio_button_checked : Icons.trip_origin,
            size: 20.0,
            color: (endTime != null) ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }
}
