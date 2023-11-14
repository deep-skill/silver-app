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
        padding:
            MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
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
