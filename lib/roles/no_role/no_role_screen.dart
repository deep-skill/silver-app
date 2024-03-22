import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/full_screen_loader.dart';
import 'package:silverapp/roles/no_role/welcome_msg_screen.dart';

class NoRoleScreen extends ConsumerWidget {
  static const name = 'no-role';
  const NoRoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Credentials? credentials = ref.watch(authProvider).credentials;
    final size = MediaQuery.of(context).size;

    return kIsWeb
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xff164772),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: credentials != null
                  ? ShowInformation(
                      size: size,
                      credentials: credentials,
                    )
                  : const FullScreenLoader(),
            ))
        : Scaffold(
            appBar: AppBar(title: const Text('Bienvenido/a')),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: credentials != null
                  ? ShowInformation(
                      size: size,
                      credentials: credentials,
                    )
                  : const FullScreenLoader(),
            ));
  }
}

class ShowInformation extends ConsumerWidget {
  final Size size;
  final Credentials? credentials;
  final Future? buttonOnpressed;
  const ShowInformation(
      {super.key, required this.size, this.credentials, this.buttonOnpressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return kIsWeb
        ? Container(
            alignment: Alignment.center,
            height: size.height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: [
                SizedBox(height: size.height * .02),
                credentials != null
                    ? Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(size.width * .02),
                            child: WelcomeMsgScreen(
                              mainImage: Image.asset(
                                'assets/images/app_logo_auth.png',
                              ),
                              title: Text(
                                '¡Bienvenido ${credentials?.user.email} \na Silver Express!',
                                style: const TextStyle(fontSize: 36),
                                textAlign: TextAlign.center,
                              ),
                              subTitle: const Text(
                                'Al parecer todavía no tienes un rol asignado.',
                                style: TextStyle(fontSize: 24),
                                textAlign: TextAlign.center,
                              ),
                              secSubTitle: const Text(
                                'Por favor, contáctate con un administrador.',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Montserrat-Regular'),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      )
                    : const Text('not logged'),
                const SizedBox(height: 8),
                TextButton(
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                      fixedSize: MaterialStateProperty.all(
                          Size(size.width * .2, size.height * .06)),
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF03132A)),
                    ),
                    child: const Text(
                      'Cerrar sesión',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Montserrat-Bold'),
                    ))
              ],
            ),
          )
        : Container(
            height: size.height,
            decoration: const BoxDecoration(
              color: Color(0xffF2F3F7),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: [
                SizedBox(height: size.height * .03),
                credentials != null
                    ? Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(size.width * .08),
                            child: WelcomeMsgScreen(
                              mainImage: Image.asset(
                                'assets/images/app_logo_auth.png',
                              ),
                              title: Text(
                                'Bienvenido/a ${credentials?.user.email} a Silver Expresss!',
                                style: TextStyle(fontSize: size.width * .08),
                                textAlign: TextAlign.center,
                              ),
                              subTitle: Text(
                                'Al parecer todavía no tienes un rol asignado.',
                                style: TextStyle(fontSize: size.width * .05),
                                textAlign: TextAlign.center,
                              ),
                              secSubTitle: Text(
                                'Por favor, contáctate con un administrador.',
                                style: TextStyle(fontSize: size.width * .03),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      )
                    : const Text('not logged'),
                ElevatedButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightBlue),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
  }
}
