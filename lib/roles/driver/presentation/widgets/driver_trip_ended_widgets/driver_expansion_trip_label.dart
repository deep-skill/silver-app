import 'package:flutter/material.dart';

class ExpansionTripLabelAmoutDriver extends StatefulWidget {
  final double priceBase;
  final double? waitingTimeExtra;

  const ExpansionTripLabelAmoutDriver(
      {super.key, required this.priceBase, required this.waitingTimeExtra});

  @override
  State<ExpansionTripLabelAmoutDriver> createState() =>
      _ExpansionTripLabelAmoutDriverState();
}

class _ExpansionTripLabelAmoutDriverState
    extends State<ExpansionTripLabelAmoutDriver> {
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
  var styleText = const TextStyle(
    color: Color(0xFF000000),
    fontFamily: "Raleway-Medium",
    fontSize: 14,
  );
  @override
  Widget build(BuildContext context) {
    double calculateRevenue() {
      if (widget.waitingTimeExtra != null) {
        return widget.priceBase + (widget.waitingTimeExtra ?? 0);
      }
      return widget.priceBase;
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF2F3F7),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ExpansionTile(
        shape: const Border(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ganancia",
              style: styleTitle,
            ),
            Text(
              " S/ ${calculateRevenue().toStringAsFixed(2)}",
              style: stylePrice,
            )
          ],
        ),
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tarifa base",
                  style: styleText,
                ),
                Row(
                  children: [
                    Text(
                      "S/ ${widget.priceBase.toStringAsFixed(2)}",
                      style: styleText,
                    ),
                    const SizedBox(
                      width: 37,
                    )
                  ],
                ),
              ],
            ),
          ),
          widget.waitingTimeExtra != null
              ? ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tiempo de espera",
                        style: styleText,
                      ),
                      Row(
                        children: [
                          Text(
                            "S/ ${widget.waitingTimeExtra}",
                            style: styleText,
                          ),
                          const SizedBox(
                            width: 37,
                          )
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
        onExpansionChanged: (bool expanded) => {},
      ),
    );
  }
}
