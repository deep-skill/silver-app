import 'package:flutter/material.dart';

class DriverTripLabelStop extends StatelessWidget {
  final String text;

  const DriverTripLabelStop({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
              SizedBox(
                width: size.width * .7,
                child: Text(
                  text,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
