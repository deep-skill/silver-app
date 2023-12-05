import 'package:flutter/material.dart';

class LabelExtraTrip extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const LabelExtraTrip({Key? key, required this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      alignment: AlignmentDirectional.bottomStart,
      child: IntrinsicWidth(
        child: Container(
          margin: EdgeInsets.only(bottom: size.height * .02),
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xffF2F3F7),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Flexible(
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
              IconButton(
                onPressed: onPressed,
                iconSize: 22,
                color: const Color(0xff1D192B),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
