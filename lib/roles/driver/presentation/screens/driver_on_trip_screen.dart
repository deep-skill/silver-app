import 'package:flutter/material.dart';

class DriverOnTripScreen extends StatelessWidget {
  const DriverOnTripScreen({super.key, required this.tripId});
  
  final String tripId;

  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: Text(tripId),

    );
  }
}