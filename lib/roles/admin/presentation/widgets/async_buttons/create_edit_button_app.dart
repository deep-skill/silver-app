import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/create_reserve.dart';

class ButtonCreateEditApp extends StatefulWidget {
  const ButtonCreateEditApp({
    Key? key,
    required this.size,
    required this.reserve,
    required this.onPressedCreateEdit,
  }) : super(key: key);

  final Future<bool?> Function() onPressedCreateEdit;
  final Size size;
  final CreateReserve reserve;

  @override
  State<ButtonCreateEditApp> createState() => _ButtonCreateEditAppState();
}

class _ButtonCreateEditAppState extends State<ButtonCreateEditApp> {
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
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        fixedSize: MaterialStateProperty.all(
            Size(widget.size.width * .8, widget.size.height * .07)),
        backgroundColor: MaterialStateProperty.all(
          _isLoading ? Colors.grey : const Color(0xFF23A5CD),
        ),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : Text(
              widget.reserve.id == 0 ? "Crear" : "Guardar cambios",
              style: const TextStyle(
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

    var value = await widget.onPressedCreateEdit();
    if (value != null) context.pop();
    setState(() {
      _isLoading = false;
    });
  }
}
