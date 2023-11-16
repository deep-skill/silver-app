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
    return Container(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => alertWidget,
          );
        },
        style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(5)),
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
      ),
    );
  }
}
