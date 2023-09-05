import 'dart:convert';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/providers/auth0_provider.dart';

class AdminScreen extends ConsumerWidget {
  static const name = 'admin';
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Credentials? credentials = ref.watch(authProvider).credentials;
//    AuthState? authState = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Admin - Details Screen auth0')),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  try {
                    final Dio dio = Dio(
                      BaseOptions(
                          baseUrl:
                              'http://${dotenv.env['YOUR_IP']}:${dotenv.env['SERVER_PORT']}/',
                          contentType: 'application/json',
                          headers: {
                            "Authorization":
                                "Bearer ${credentials!.accessToken}"
                          }),
                    );
                    final response = await dio.get(
                      '/user/',
                    );
                    final data = response.data.toString();
                    print(data);
                  } catch (error) {
                    throw Exception(error);
                  }
                },
                child: const Text("Obtener usuarios")),
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  final Dio dio = Dio(
                    BaseOptions(
                        baseUrl:
                            'http://${dotenv.env['YOUR_IP']}:${dotenv.env['SERVER_PORT']}/',
                        contentType: 'application/json',
                        headers: {
                          "Authorization": "Bearer ${credentials!.accessToken}"
                        }),
                  );
                  final response = await dio.post('user/',
                      data: jsonEncode({
                        "name": "Abc123",
                        "email": "email4@email.com",
                        "phone": "+51-84-574-860",
                        "address": "Jr. Andahuaylas 449, Lima 15001, Peru",
                        "license": "Q84736203"
                      }));
                  final data = response.data.toString();
                  print(data);
                } catch (error) {
                  throw Exception(error);
                }
              },
              child: const Text("Crear usuario")),
          ElevatedButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}



/* TextButton(
  onPressed: () {
    context.push('/details');
    },
  child: const Text('Test Acá')
  ),
  Text(
    auth0Prov.authStatus.toString(),
    style: const TextStyle(fontSize: 20),
  ), */

  /* 
    auth0Prov.credentials != null
                  /                 ? ElevatedButton(
                                        onPressed: () {
                                          ref
                                              .read(authProvider.notifier)
                                              .logout();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xFFFFFFFF)),
                                        ),
                                        child: Text(
                                          'Salir ${auth0Prov.credentials!.scopes}',
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
                                          ref
                                              .read(authProvider.notifier)
                                              .login();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xFFFFFFFF)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.width * .10,
                                              vertical: size.height * .015),
                                          child: Text(
                                            'Ingresar',
                                            style: TextStyle(
                                              color: colors.onBackground,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
   */