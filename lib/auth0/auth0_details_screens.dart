import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/providers/auth0_provider.dart';

class DetailsScreen extends ConsumerWidget {
  static const name = 'details';
  const DetailsScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Credentials? credentials = ref.watch(authProvider).credentials; 
    return Scaffold(
      appBar: AppBar(title: const Text('Details Screen auth0')),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () => context.go('/'),
              child:
              credentials != null
              ? Text(credentials.accessToken)
              : const Text('not logged')
            ),
          ),
          ElevatedButton(
                onPressed: () {
                   ref.read(authProvider.notifier).logout();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: const Text('Logout'),
              )
        ],
      ),
    );
  }
}

