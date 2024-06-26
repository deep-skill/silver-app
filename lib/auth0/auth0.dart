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
                            'assets/images/app_logo_letters.png',
                            width: kIsWeb ? size.width * .45 : size.width * .85,
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: kIsWeb ? size.width * .30 : size.width * .70,
                    child: const LinearProgressIndicator(
                      color: Colors.white,
                    ),
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
        height: size.height * .14,
      ),
      SizedBox(
        height: size.height * .12,
        width: size.width * .60,
        child: Image.asset('assets/images/silver-logo_white_font-color.png'),
      ),
      SizedBox(
        height: size.height * .01,
      ),
      SizedBox(
        height: size.height * .30,
        width: size.width * .9,
        child: Image.asset('assets/images/login-driving-car.png'),
      ),
      SizedBox(
        height: size.height * .03,
      ),
      SizedBox(
        width: size.width * .9,
        child: Text(
          'Gestiona tus viajes corporativos con un solo clic',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.onPrimary,
            fontSize: 23,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      SizedBox(
        height: size.height * .05,
      ),
      SizedBox(
        height: size.height * .06,
        width: size.width * .8,
        child: ElevatedButton(
          onPressed: () {
            ref.read(authProvider.notifier).login();
          },
          child: Text(
            'Ingresar',
            style: TextStyle(
              color: colors.onBackground,
              fontSize: 16,
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
    final Size size = MediaQuery.of(context).size;
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 80),
              child: Image.asset(
                'assets/images/silver-logo_white_font-color.png',
                width: size.width * .20,
              ),
            ),
            SizedBox(
              height: size.height * .01,
            ),
            SizedBox(
              width: size.width * .50,
              child: Padding(
                padding: const EdgeInsets.only(left: 100, right: 120),
                child: Text(
                  'Gestiona tus viajes corporativos con un solo clic',
                  style: TextStyle(
                    height: 1.2,
                    color: colors.onPrimary,
                    fontSize: size.height * .07,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * .08,
            ),
            SizedBox(
              width: size.width * .5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).login();
                  },
                  child: Text(
                    'Ingresar',
                    style: TextStyle(
                      color: colors.onBackground,
                      fontSize: size.height * .035,
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
