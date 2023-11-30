import 'package:flutter/material.dart';

Widget _buildDeleteDialog() {
  return const AlertDialog(
    title: Text(
      'Eliminando reserva...',
      style: TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
    ),
    content: CircularProgressIndicator(),
    actions: [],
  );
}
