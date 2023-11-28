import 'package:flutter/material.dart';

class TripLabelStop extends StatelessWidget {
  final String text;

  const TripLabelStop({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.bottomStart,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(2),
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: Row(
            children: [
              Icon(
                Icons.add_location_alt,
                color: Colors.grey[600],
              ),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
