import 'package:flutter/material.dart';

class TripLabelAmout extends StatelessWidget {
  final String textAmout;
  final String textTipePrice;

  const TripLabelAmout({
    Key? key,
    required this.textAmout,
    required this.textTipePrice,
  }) : super(key: key);

  final TextStyle textPrice = const TextStyle(
    fontFamily: "Montserrat-Bold",
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF2F3F7),
        borderRadius: BorderRadius.circular(12.0),
      ),
      width: MediaQuery.of(context).size.width * .6,
      height: MediaQuery.of(context).size.height * .07,
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(textTipePrice),
          Text(
            textAmout,
            style: textPrice,
          ),
        ],
      ),
    );
  }
}
