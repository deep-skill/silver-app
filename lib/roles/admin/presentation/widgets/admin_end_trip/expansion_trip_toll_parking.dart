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
  var _customIcon = false;

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
                  const Text("Adicionales"),
                  Text(
                    " S/ ${(widget.priceToll ?? 0) + (widget.priceParking ?? 0)}",
                  )
                ],
              ),
              children: [
                widget.priceToll != null
                    ? ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Peajes"),
                            Row(
                              children: [
                                Text("S/ ${widget.priceToll}"),
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
                            const Text("Estacionamiento"),
                            Row(
                              children: [
                                Text("S/ ${widget.priceParking}"),
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
              onExpansionChanged: (bool expanded) =>
                  {setState(() => _customIcon = expanded)},
            ),
          )
        ],
      ),
    );
  }
}
