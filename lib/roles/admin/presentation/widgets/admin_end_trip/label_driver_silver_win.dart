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
    return SizedBox(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .6,
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
                        Text(description),
                      ],
                    ),
                    Row(
                      children: [
                        Text(priceText),
                        const SizedBox(
                          width: 60,
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
