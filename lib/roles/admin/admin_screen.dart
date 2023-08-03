import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/providers/auth0_provider.dart';

class AdminScreen extends ConsumerWidget {
  static const name = 'admin';
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Credentials? credentials = ref.watch(authProvider).credentials;
    AuthState? authState = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Admin - Details Screen auth0')),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () =>
                    print(authState!.credentials!.scopes.toString()),
                child: credentials != null
                    ? Column(
                        children: [
                          Text(credentials.accessToken),
                          Text(credentials.scopes.toString()),
                        ],
                      )
                    : const Text('not logged')),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            child: const Text('Logout'),
          )
        ],
      ),
    );
  }
}
