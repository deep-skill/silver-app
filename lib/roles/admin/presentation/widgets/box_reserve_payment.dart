import 'package:flutter/material.dart';

class BoxReservePayment extends StatelessWidget {
  final String label;
  final String text;
  const BoxReservePayment({super.key, required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .20,
          child: Column(
            children: [
              Text(
                label,
                maxLines: 2,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 2.0,
          height: 50.0,
          color: Colors.black,
        ),
      ],
    );
  }
}
