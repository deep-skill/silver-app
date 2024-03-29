import 'package:flutter/material.dart';

class LabelDriverSilverWin extends StatelessWidget {
  final String description;
  final String priceText;
  const LabelDriverSilverWin({
    super.key,
    required this.description,
    required this.priceText,
  });

  @override
  Widget build(BuildContext context) {
    var styleTitle = const TextStyle(
      color: Color(0xFF000000),
      fontFamily: 'Raleway-Medium',
      fontSize: 16,
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
                    style: styleTitle,
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
