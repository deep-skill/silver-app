import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_nearest_reserve_provider.dart';

class BackHomeButton extends ConsumerWidget {
  final String buttonText;

  const BackHomeButton({
    Key? key,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        ref.invalidate(nearestReserveProvider);
        context.go("/driver");
        },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(5)),
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0xFF23A5CD)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          fontFamily: "Monserrat",
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
