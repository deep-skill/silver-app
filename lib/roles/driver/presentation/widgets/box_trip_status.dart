import 'package:flutter/material.dart';

class TripStatus extends StatelessWidget {
  final String status;

  const TripStatus({
    super.key,
    required this.status,
  });

  bool getStatusPointOfOrigin() {
    switch (status) {
      case "PointOfOrigin":
        return true;
      case "JourneyStarted":
        return true;
      case "Finalizado":
        return true;
      default:
        return false;
    }
  }

  bool getJourneyStarted() {
    switch (status) {
      case "PointOfOrigin":
        return false;
      case "JourneyStarted":
        return true;
      case "Finalizado":
        return true;
      default:
        return false;
    }
  }

  bool getTripCompleted() {
    switch (status) {
      case "PointOfOrigin":
        return false;
      case "JourneyStarted":
        return false;
      case "Finalizado":
        return true;
      default:
        return false;
    }
  }

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
            color: (getStatusPointOfOrigin()) ? Colors.green : Colors.grey,
            padding: const EdgeInsets.all(2.0),
          ),
          Icon(
            (getStatusPointOfOrigin())
                ? Icons.radio_button_checked
                : Icons.trip_origin,
            size: 20.0,
            color: (getStatusPointOfOrigin()) ? Colors.green : Colors.grey,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .18,
            height: 2.0,
            color: (getJourneyStarted()) ? Colors.green : Colors.grey,
            padding: const EdgeInsets.all(2.0),
          ),
          Icon(
            (getJourneyStarted())
                ? Icons.radio_button_checked
                : Icons.trip_origin,
            size: 20.0,
            color: (getJourneyStarted()) ? Colors.green : Colors.grey,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .18,
            height: 2.0,
            color: (getTripCompleted()) ? Colors.green : Colors.grey,
            padding: const EdgeInsets.all(2.0),
          ),
          Icon(
            (getTripCompleted())
                ? Icons.radio_button_checked
                : Icons.trip_origin,
            size: 20.0,
            color: (getTripCompleted()) ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }
}
