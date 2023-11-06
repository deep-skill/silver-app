import 'package:flutter/material.dart';

class DateAndTextWidget extends StatelessWidget {
  final Size size;
  final DateTime date;
  final List<String> months;

  DateAndTextWidget({
    required this.size,
    required this.date,
    required this.months,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.01,
        ),
        SizedBox(
          width: size.width * 0.9,
          child: Text(
            months[date.month - 1],
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
      ],
    );
  }
}
