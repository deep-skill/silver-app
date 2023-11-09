import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/no_role/WelcomeMsgScreen.dart';

class NoRoleScreen extends ConsumerWidget {
  static const name = 'no-role';
  const NoRoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Credentials? credentials = ref.watch(authProvider).credentials;
    final size = MediaQuery.of(context).size;
    final String? userName = credentials?.user.nickname;
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Column(
        children: [
          SizedBox(height: size.height * .03),
          credentials != null
              ? Column(
                  children: [
                    // Text(credentials.accessToken),
                    // Text(credentials.scopes.toString()),
                    Padding(
                      padding: EdgeInsets.all(size.width * .08),
                      child: WelcomeMsgScreen(
                        mainImage: Image.asset(
                          'assets/images/app_logo_auth.png',
                        ),
                        title: Text(
                          'Bienvenido/a $userName a Silver Expresss!',
                          style: TextStyle(fontSize: size.width * .08),
                          textAlign: TextAlign.center,
                        ),
                        subTitle: Text(
                          'Al parecer todavía no tienes un rol asignado',
                          style: TextStyle(fontSize: size.width * .05),
                          textAlign: TextAlign.center,
                        ),
                        secSubTitle: Text(
                          'Por favor, contáctate con un administrador',
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
