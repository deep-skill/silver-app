import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/full_screen_loader.dart';
import 'package:silverapp/roles/no_role/WelcomeMsgScreen.dart';

class DriverWebDenyScreen extends ConsumerWidget {
  static const name = 'no-role';
  const DriverWebDenyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Credentials? credentials = ref.watch(authProvider).credentials;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: credentials != null
          ? ShowInformation(
              size: size,
              credentials: credentials,
            )
          : const FullScreenLoader(),
    );
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
    return Container(
      height: size.height,
      decoration: const BoxDecoration(
        color: Color(0xffF2F3F7),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: [
          SizedBox(height: size.height * .03),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(size.width * .08),
                child: WelcomeMsgScreen(
                  mainImage: Image.asset(
                    'assets/images/app_logo_auth.png',
                  ),
                  title: Text(
                    'Hola, Conductor!',
                    style: TextStyle(fontSize: size.width * .08),
                    textAlign: TextAlign.center,
                  ),
                  subTitle: Text(
                    '¿Deseas revisar o iniciar algun viaje?',
                    style: TextStyle(fontSize: size.width * .05),
                    textAlign: TextAlign.center,
                  ),
                  secSubTitle: Text(
                    'Descarga la app de Silver Express.',
                    style: TextStyle(fontSize: size.width * .03),
                    textAlign: TextAlign.center,
                  ),
                  secondImage: Image.asset(
                    'assets/images/apple_store.png',
                    width: size.width * .35,
                    height: size.height * .08,
                  ),
                  thirdImage: Image.asset(
                    'assets/images/google_store.png',
                    width: size.width * .35,
                    height: size.height * .15,
                  ),
                ),
              )
            ],
          ),
          ElevatedButton(
            onPressed: () {
              print('Abrir en play store, apple store');
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.lightBlue),
            ),
            child: const Text(
              'Abrir en mi Store',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
