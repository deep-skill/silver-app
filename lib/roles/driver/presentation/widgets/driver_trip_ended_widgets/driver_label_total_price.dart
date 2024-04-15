import 'package:flutter/material.dart';

class LabelTotalPriceDriver extends StatelessWidget {
  final String description;
  final String priceText;
  const LabelTotalPriceDriver({
    super.key,
    required this.description,
    required this.priceText,
  });

  @override
  Widget build(BuildContext context) {
    var styleTitle = const TextStyle(
      color: Color(0xFF164772),
      fontFamily: 'Raleway-Bold',
      fontSize: 16,
    );
    var stylePrice = const TextStyle(
      color: Color(0xFF164772),
      fontFamily: 'Raleway-Bold',
      fontSize: 24,
    );
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    description,
                    style: styleTitle,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    priceText,
                    style: stylePrice,
                  ),
                  const SizedBox(
                    width: 60,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
