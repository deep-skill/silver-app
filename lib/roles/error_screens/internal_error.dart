import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silverapp/roles/no_role/welcome_msg_screen.dart';

class InternalErrorScreen extends StatelessWidget {
  const InternalErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return kIsWeb
        ? Scaffold(
            body: Padding(
              padding: EdgeInsets.only(
                  top: size.height * .07,
                  left: size.height * .015,
                  right: size.height * .015,
                  bottom: size.height * .015),
              child: const InternalErrorInfo(),
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
              child: const InternalErrorInfo(),
            ),
          );
  }
}

class InternalErrorInfo extends StatelessWidget {
  const InternalErrorInfo({super.key});

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
                      title: Text(
                        "¡Oops!",
                        style: TextStyle(
                            fontSize: size.height * .1,
                            color: Colors.black,
                            fontFamily: 'Montserrat-Regular'),
                        textAlign: TextAlign.center,
                      ),
                      subTitle: const Text(
                        "Error interno del servidor.",
                        style: TextStyle(fontSize: 24, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      mainImage:
                          Image.asset('assets/images/internal_error.png')),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                          Size(size.width * .25, size.height * .02)),
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
                      "Error interno del servidor.",
                      style: TextStyle(fontSize: size.width * .07),
                      textAlign: TextAlign.center,
                    ),
                    mainImage: Image.asset('assets/images/internal_error.png')),
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
