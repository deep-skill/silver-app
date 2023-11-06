import 'package:flutter/material.dart';

class TripButton extends StatelessWidget {
  final String buttonText;
  final Widget alertWidget;

  const TripButton({
    Key? key,
    required this.buttonText,
    required this.alertWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => alertWidget,
        );
      },
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
