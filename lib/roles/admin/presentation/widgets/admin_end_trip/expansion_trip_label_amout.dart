import 'package:flutter/material.dart';

class ExpansionTripLabelAmout extends StatefulWidget {
  final double priceBase;
  final double? waitingTimeExtra;

  const ExpansionTripLabelAmout(
      {super.key, required this.priceBase, required this.waitingTimeExtra});

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
  var styleText = const TextStyle(
    color: Color(0xFF000000),
    fontFamily: "Raleway-Medium",
    fontSize: 14,
  );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffF2F3F7),
              borderRadius: BorderRadius.circular(12.0),
            ),
            width: MediaQuery.of(context).size.width * .6,
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
            child: ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Precio del viaje",
                    style: styleTitle,
                  ),
                  Text(
                    " S/ ${widget.priceBase + (widget.waitingTimeExtra ?? 0)}",
                    style: styleTitle,
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
                            "S/ ${widget.priceBase}",
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
          )
        ],
      ),
    );
  }
}
