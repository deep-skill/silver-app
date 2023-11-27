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
    fontFamily: "Raleway",
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12.0),
      ),
      width: MediaQuery.of(context).size.width * .6,
      height: MediaQuery.of(context).size.height * .06,
      margin: const EdgeInsets.all(6.0),
      padding: const EdgeInsets.all(6.0),
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
