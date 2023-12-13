import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BoxReservePayment extends StatelessWidget {
  final String label;
  final String text;
  const BoxReservePayment({super.key, required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return kIsWeb
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .08,
                child: Column(
                  children: [
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat-Semi-Bold',
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 17),
                    Text(
                      text,
                      style: const TextStyle(
                          fontSize: 15, fontFamily: 'Montserrat-Bold'),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1.5,
                height: 60.0,
                color: Colors.black,
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * .21,
                height: size.height * .08,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat-Regular',
                        fontSize: size.width * .033,
                      ),
                    ),
                    Text(
                      text,
                      style: TextStyle(
                          fontSize: size.width * .045,
                          fontFamily: 'Montserrat-Bold'),
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width * .003,
                height: size.height * .08,
                color: Colors.black,
              ),
            ],
          );
  }
}
