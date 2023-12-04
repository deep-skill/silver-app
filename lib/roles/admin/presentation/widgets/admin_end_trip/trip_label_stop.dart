import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TripLabelStop extends StatelessWidget {
  final String text;

  const TripLabelStop({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                width: kIsWeb ? size.width * .27 : size.width * .75,
                child: Flexible(
                  child: Text(
                    text,
                    style: const TextStyle(
                        fontFamily: 'Roboto-Bold',
                        fontSize: 14,
                        color: Color(0xff1D192B)),
                    maxLines: 2,
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
