import 'package:flutter/material.dart';

class WelcomeMsgScreen extends StatelessWidget {
  final String? userName;
  final Text title;
  final Text subTitle;
  final Text? secSubTitle;
  final Image mainImage;

  const WelcomeMsgScreen({
    super.key,
    this.userName,
    required this.title,
    required this.subTitle,
    this.secSubTitle,
    required this.mainImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        mainImage,
        const SizedBox(
          height: 15,
        ),
        title,
        const SizedBox(
          height: 15,
        ),
        subTitle,
        const SizedBox(
          height: 15,
        ),
        secSubTitle ?? const Text(''),
      ],
    );
  }
}
