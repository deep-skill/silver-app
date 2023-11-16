import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackHomeButton extends StatelessWidget {
  final String buttonText;

  const BackHomeButton({
    Key? key,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.pop("/driver"),
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
