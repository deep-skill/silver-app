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
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xffF2F3F7),
          ),
          child: Row(
            children: [
              const SizedBox(width: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * .27,
                child: Flexible(
                  child: Text(
                    text,
                    style: const TextStyle(
                        fontFamily: 'Roboto-Bold',
                        fontSize: 14,
                        color: Color(0xff1D192B)),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
