import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:silverapp/roles/admin/presentation/widgets/full_screen_loader.dart';

Widget buildDeleteDialog(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return AlertDialog(
    title: const Text(
      'Eliminando reserva...',
      style: TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    content: SizedBox(
      width: size.width * .7,
      height: size.height * .1,
      child: SpinPerfect(
        duration: const Duration(seconds: 1),
        child: const FullScreenLoader(),
      ),
    ),
    actions: [],
  );
}
