import 'package:flutter/material.dart';

class NewTripLabelAmout extends StatefulWidget {
  final double priceBase;
  final double? waitingTimeExtra;

  const NewTripLabelAmout(
      {super.key, required this.priceBase, required this.waitingTimeExtra});

  @override
  State<NewTripLabelAmout> createState() => _NewTripLabelAmoutState();
}

class _NewTripLabelAmoutState extends State<NewTripLabelAmout> {
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
                  Text("Precio del viaje"),
                  Text(
                    " S/ ${widget.priceBase + (widget.waitingTimeExtra ?? 0)}",
                  )
                ],
              ),
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Tarifa base"),
                      Row(
                        children: [
                          Text("S/ ${widget.priceBase}"),
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
                            const Text("Tiempo de espera"),
                            Row(
                              children: [
                                Text("S/ ${widget.waitingTimeExtra}"),
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
