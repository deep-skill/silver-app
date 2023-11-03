import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  CustomCard({required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.bottomStart,
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Text(text),
              IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.cancel_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
