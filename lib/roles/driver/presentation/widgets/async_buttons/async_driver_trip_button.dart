import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonAsyncDriverTrip extends StatefulWidget {
  const ButtonAsyncDriverTrip({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Future<bool?> Function() onPressed;

  @override
  State<ButtonAsyncDriverTrip> createState() => _ButtonAsyncDriverTripState();
}

class _ButtonAsyncDriverTripState extends State<ButtonAsyncDriverTrip> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (!_isLoading) {
          _onPressedHandler();
        }
      },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all(
            _isLoading ? Colors.grey : const Color(0xFF23A5CD)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 1,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              "Confirmar",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Raleway-Semi-Bold',
                fontSize: 16,
              ),
            ),
    );
  }

  void _onPressedHandler() async {
    setState(() {
      _isLoading = true;
    });
    var value = await widget.onPressed();
    setState(() {
      _isLoading = false;
    });
    if (value != null) context.pop();
  }
}
