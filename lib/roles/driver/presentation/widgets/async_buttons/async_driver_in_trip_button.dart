import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonAsyncDriverInTrip extends StatefulWidget {
  const ButtonAsyncDriverInTrip({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Future<void> Function() onPressed;

  @override
  State<ButtonAsyncDriverInTrip> createState() =>
      _ButtonAsyncDriverInTripState();
}

class _ButtonAsyncDriverInTripState extends State<ButtonAsyncDriverInTrip> {
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
    await widget.onPressed();
    setState(() {
      _isLoading = false;
    });
    context.pop();
  }
}
