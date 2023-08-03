import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth0_provider.dart';

class Auth0Screen extends ConsumerStatefulWidget {
  static const name = 'login';
  const Auth0Screen({final Key? key}) : super(key: key);

  @override
  Auth0ScreenState createState() => Auth0ScreenState();
}

class Auth0ScreenState extends ConsumerState<Auth0Screen> {
  @override
  Widget build(BuildContext context) {
    final auth0Prov = ref.watch(authProvider);
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: auth0Prov.authStatus == AuthStatus.checking
          ? Container(
              color: colors.primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/silver-logo_white_font-color.png'),
                  const SizedBox(
                    height: 30,
                  ),
                  const CircularProgressIndicator(
                    strokeWidth: 4,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          : Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [colors.primary, const Color(0xff23A5CD)]),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    kIsWeb
                        ? const SizedBox(
                            height: 0,
                          )
                        : SizedBox(
                            height: size.height * .15,
                          ),
                    Text(
                      'Bienvenido!',
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontSize: 50,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Image.asset(
                        'assets/images/silver-logo_white_font-color.png'),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Ingresa',
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontSize: 35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    auth0Prov.credentials != null
                        ? ElevatedButton(
                            onPressed: () {
                              ref.read(authProvider.notifier).logout();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFFFFFFFF)),
                            ),
                            child: Text(
                              'Logout ${auth0Prov.credentials!.scopes}',
                              style: TextStyle(
                                color: colors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              ref.read(authProvider.notifier).login();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFFFFFFFF)),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: colors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                    SizedBox(
                      height: size.height * .15,
                    ),
                    const Text(
                      '¿Quieres Trabajar con nosotros?',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'CONTACTANOS',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Acción al presionar el botón de WhatsApp
                            // Abre el enlace correspondiente
                          },
                          icon: const Icon(
                            Icons.call,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Acción al presionar el botón de Facebook
                            // Abre el enlace correspondiente
                          },
                          icon: const Icon(
                            Icons.facebook,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Acción al presionar el botón de Gmail
                            // Abre el enlace correspondiente
                          },
                          icon: const Icon(
                            Icons.mail,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    /* TextButton(
                        onPressed: () {
                          context.push('/details');
                        },
                        child: const Text('Ingresa aquíaaa')),
                    Text(
                      auth0Prov.authStatus.toString(),
                      style: const TextStyle(fontSize: 20),
                    ), */
                  ]),
            ),
    );
  }
}
