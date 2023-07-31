import 'package:flutter/material.dart';


class HeroWidget extends StatelessWidget {
  const HeroWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Image.asset('images/logo.png', width: 24),
      ),
      Expanded(
          child: Container(
              margin: const EdgeInsets.all(16),
              child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Flutter',
                        ),
                    Text('Sample App',
                        ),
                  ])))
    ]);
  }
}
