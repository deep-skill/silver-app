import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth0_provider.dart';
import 'hero.dart';
import 'user.dart';

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
    return Padding(
      padding: const EdgeInsets.only(
        top: 40,
        bottom: 40,
        left: 40 / 2,
        right: 40 / 2,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
            child: Row(children: [
          auth0Prov.credentials != null
              ? Expanded(child: UserWidget(user: auth0Prov.credentials!.user))
              : const Expanded(child: HeroWidget()),
              Text(auth0Prov.authStatus.toString(), style: TextStyle(fontSize: 10),),
        ])),
        auth0Prov.credentials != null
            ? ElevatedButton(
                onPressed: () {
                   ref.read(authProvider.notifier).logout();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: const Text('Logout'),
              )
            : ElevatedButton(
                   onPressed: (){
                    ref.read(authProvider.notifier).login();
                   },                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: const Text('Login'),
              ),
        TextButton(
            onPressed: () {
              context.push('/details');
            },
            child: const Text('Ingresa aquíaaa')),
      ]),
    );
  }
}
