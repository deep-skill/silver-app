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
              color: const Color(0xff03132a),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: size.width,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/app_logo.png',
                            width: kIsWeb ? size.width * .10 : size.width * .30,
                          ),
                          Image.asset(
                            'assets/images/app_logo_letters.png',
                            width: kIsWeb ? size.width * .30 : size.width * .70,
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
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
              decoration: const BoxDecoration(
                color: Color(0xff03132a),
              ),
              child: kIsWeb
                  ? WebLoginView(size: size, colors: colors, ref: ref)
                  : AppLoginView(
                      size: size,
                      colors: colors,
                      auth0Prov: auth0Prov,
                      ref: ref),
            ),
    );
  }
}

class AppLoginView extends StatelessWidget {
  const AppLoginView({
    super.key,
    required this.size,
    required this.colors,
    required this.auth0Prov,
    required this.ref,
  });

  final Size size;
  final ColorScheme colors;
  final AuthState auth0Prov;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        height: size.height * .15,
      ),
      SizedBox(
        width: size.width * .70,
        child: Image.asset('assets/images/silver-logo_white_font-color.png'),
      ),
      const SizedBox(
        height: 10,
      ),
      Image.asset('assets/images/login-driving-car.png'),
      const SizedBox(
        height: 15,
      ),
      Text(
        '¡Bienvenido a Silver!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colors.onPrimary,
          fontSize: 31,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Text(
          'Gestiona los viajes corporativos de tus clientes y empleados con un solo clic.',
          style: TextStyle(
            color: colors.onPrimary,
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(
        height: 40,
      ),
      SizedBox(
        width: size.width * .7,
        child: ElevatedButton(
          onPressed: () {
            ref.read(authProvider.notifier).login();
          },
          child: Text(
            'Ingresar',
            style: TextStyle(
              color: colors.onBackground,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ]);
  }
}

class WebLoginView extends StatelessWidget {
  const WebLoginView({
    super.key,
    required this.size,
    required this.colors,
    required this.ref,
  });

  final Size size;
  final ColorScheme colors;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Image.asset(
                'assets/images/silver-logo_white_font-color.png',
                width: size.width * .20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: size.width * .50,
              child: Padding(
                padding: const EdgeInsets.only(left: 80),
                child: Text(
                  '¡Bienvenido a Silver!',
                  style: TextStyle(
                    height: 1.2,
                    color: colors.onPrimary,
                    fontSize: 70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: size.width * .50,
              child: Padding(
                padding: const EdgeInsets.only(left: 80),
                child: Text(
                  'Gestiona los viajes corporativos de tus clientes y empleados con un solo clic.',
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: size.width * .5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).login();
                  },
                  child: Text(
                    'Ingresar',
                    style: TextStyle(
                      color: colors.onBackground,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            )
          ]),
      SizedBox(
        width: size.width * .5,
        child: Padding(
          padding: const EdgeInsets.only(right: 100),
          child: Image.asset(
            'assets/images/login-driving-car-web.png',
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    ]);
  }
}
