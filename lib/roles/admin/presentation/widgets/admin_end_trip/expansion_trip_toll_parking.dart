import 'package:flutter/material.dart';

class ExpansionTripLabelTollParking extends StatefulWidget {
  final double? priceToll;
  final double? priceParking;

  const ExpansionTripLabelTollParking(
      {super.key, required this.priceToll, required this.priceParking});

  @override
  State<ExpansionTripLabelTollParking> createState() =>
      _ExpansionTripLabelTollParking();
}

class _ExpansionTripLabelTollParking
    extends State<ExpansionTripLabelTollParking> {
  @override
  Widget build(BuildContext context) {
    var styleTitle = const TextStyle(
      color: Color(0xFF164772),
      fontFamily: "Raleway-Bold",
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
              "Adicionales",
              style: styleTitle,
            ),
            Text(
              " S/ ${((widget.priceToll ?? 0) + (widget.priceParking ?? 0)).toStringAsFixed(2)}",
              style: stylePrice,
            )
          ],
        ),
        children: [
          widget.priceToll != null
              ? ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Peajes",
                        style: styleText,
                      ),
                      Row(
                        children: [
                          Text(
                            "S/ ${widget.priceToll!.toStringAsFixed(2)}",
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
          widget.priceParking != null
              ? ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Estacionamiento",
                        style: styleText,
                      ),
                      Row(
                        children: [
                          Text(
                            "S/ ${widget.priceParking!.toStringAsFixed(2)}",
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
