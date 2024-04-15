import 'package:flutter/material.dart';

class ExpansionTripLabelAmout extends StatefulWidget {
  final double priceBase;
  final double? waitingTimeExtra;
  final int? suggestedTotalPrice;

  const ExpansionTripLabelAmout(
      {super.key,
      required this.priceBase,
      required this.waitingTimeExtra,
      required this.suggestedTotalPrice});

  @override
  State<ExpansionTripLabelAmout> createState() =>
      _ExpansionTripLabelAmoutState();
}

class _ExpansionTripLabelAmoutState extends State<ExpansionTripLabelAmout> {
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF2F3F7),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 15),
        shape: const Border(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Precio del viaje",
              style: styleTitle,
            ),
            Text(
              " S/ ${(widget.priceBase + (widget.waitingTimeExtra ?? 0)).toStringAsFixed(2)}",
              style: stylePrice,
            )
          ],
        ),
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Tarifa base",
                      style: styleText,
                    ),
                    widget.suggestedTotalPrice != null
                        ? Tooltip(
                            decoration: BoxDecoration(
                              color: const Color(0xff031329),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            margin: const EdgeInsets.all(4.0),
                            message:
                                "Tarifa base sugerida ${(widget.suggestedTotalPrice ?? 0).toStringAsFixed(2)}",
                            textStyle: const TextStyle(color: Colors.white),
                            child: IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed: () {},
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                Text(
                  "S/ ${widget.priceBase.toStringAsFixed(2)}",
                  style: styleText,
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
                            "S/ ${widget.waitingTimeExtra!.toStringAsFixed(2)}",
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
