import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silverapp/roles/no_role/welcome_msg_screen.dart';

class PageNotFoundScreen extends StatelessWidget {
  const PageNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return kIsWeb
        ? Scaffold(
            body: Padding(
              padding: EdgeInsets.only(
                  top: size.height * .03,
                  left: size.height * .015,
                  right: size.height * .015,
                  bottom: size.height * .015),
              child: const PageNotFoundInfo(),
            ),
            backgroundColor: const Color(0xffF2F3F7),
          )
        : Scaffold(
            body: Padding(
              padding: EdgeInsets.only(
                  top: size.height * .07,
                  left: size.height * .015,
                  right: size.height * .015,
                  bottom: size.height * .015),
              child: const PageNotFoundInfo(),
            ),
          );
  }
}

class PageNotFoundInfo extends StatelessWidget {
  const PageNotFoundInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return kIsWeb
        ? Center(
            child: Container(
              height: size.height * .8,
              width: size.width * .9,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  WelcomeMsgScreen(
                      title: const Text(
                        "¡Oops!",
                        style: TextStyle(fontSize: 40),
                        textAlign: TextAlign.center,
                      ),
                      subTitle: const Text(
                        "Página no encontrada.",
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      mainImage:
                          Image.asset('assets/images/page_not_found.png')),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                          Size(size.width * .25, size.height * .03)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xff23A5CD)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Ir al inicio',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          )
        : Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
              color: Color(0xffF2F3F7),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WelcomeMsgScreen(
                    title: Text(
                      "¡Oops!",
                      style: TextStyle(fontSize: size.width * .1),
                      textAlign: TextAlign.center,
                    ),
                    subTitle: Text(
                      "Página no encontrada.",
                      style: TextStyle(fontSize: size.width * .08),
                      textAlign: TextAlign.center,
                    ),
                    mainImage: Image.asset('assets/images/page_not_found.png')),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                        Size(size.width * .8, size.width * .1)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightBlue),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Ir al inicio',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
  }
}
