import 'package:flutter/material.dart';

class LabelExtraTrip extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const LabelExtraTrip({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      alignment: AlignmentDirectional.bottomStart,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300],
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
              child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          )),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.cancel_outlined),
          ),
        ],
      ),
    );
  }
}
