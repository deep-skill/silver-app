import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BoxReserveDetail extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String? text;
  final bool? row;
  final bool? rowTriple;

  const BoxReserveDetail({
    super.key,
    this.icon,
    required this.label,
    required this.text,
    this.row,
    this.rowTriple,
  });

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Row(
            children: [
              icon != null
                  ? Icon(
                      icon,
                    )
                  : const Text(''),
              const SizedBox(width: 8.0),
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    (row == true ? .08 : .25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFF23A5CD),
                        fontFamily: 'Montserrat-Medium',
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(text.toString(),
                        maxLines: 2,
                        style: const TextStyle(
                          fontFamily: 'Montserrat-Medium',
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ],
                ),
              ),
            ],
          )
        : Row(
            children: [
              icon != null
                  ? Icon(
                      icon,
                    )
                  : const Text(''),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFF23A5CD),
                        fontFamily: 'Montserrat-Medium',
                        fontSize: 12,
                      ),
                    ),
                    Text(text.toString(),
                        maxLines: 2,
                        style: const TextStyle(
                          fontFamily: 'Montserrat-Regular',
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        )),
                    Container(
                      height: 0.0,
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
