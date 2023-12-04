import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WelcomeMsgScreen extends StatelessWidget {
  final String? userName;
  final Text title;
  final Text subTitle;
  final Text? secSubTitle;
  final Image mainImage;
  final Image? secondImage;
  final Image? thirdImage;

  const WelcomeMsgScreen(
      {super.key,
      this.userName,
      required this.title,
      required this.subTitle,
      required this.mainImage,
      this.secSubTitle,
      this.secondImage,
      this.thirdImage});

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Column(
            children: [
              mainImage,
              const SizedBox(
                height: 50,
              ),
              title,
              const SizedBox(
                height: 15,
              ),
              subTitle,
              const SizedBox(
                height: 40,
              ),
              secSubTitle ?? const SizedBox(),
              secondImage != null && thirdImage != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                          secondImage ?? const SizedBox(),
                          thirdImage ?? const SizedBox()
                        ])
                  : const SizedBox()
            ],
          )
        : Column(
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
              secSubTitle ?? const SizedBox(),
              secondImage != null && thirdImage != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                          secondImage ?? const SizedBox(),
                          thirdImage ?? const SizedBox()
                        ])
                  : const SizedBox()
            ],
          );
  }
}
