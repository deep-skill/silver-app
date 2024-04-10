import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonStartTrip extends StatefulWidget {
  const ButtonStartTrip({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Future<bool?> Function() onPressed;

  @override
  State<ButtonStartTrip> createState() => _ButtonStartTripState();
}

class _ButtonStartTripState extends State<ButtonStartTrip> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        print("aprete el boton");
        if (!_isLoading) {
          _onPressedHandler();
          print('onPressedHandler');
          print('-----------------');
          print('-----------------');
        }
        print("_isLoading ${_isLoading}");
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
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
