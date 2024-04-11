import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/create_reserve.dart';

class ButtonCreateEditWeb extends StatefulWidget {
  const ButtonCreateEditWeb({
    Key? key,
    required this.size,
    required this.reserve,
    required this.onPressedCreateEdit,
  }) : super(key: key);

  final Future<bool?> Function() onPressedCreateEdit;
  final Size size;
  final CreateReserve reserve;

  @override
  State<ButtonCreateEditWeb> createState() => _ButtonCreateEditWebState();
}

class _ButtonCreateEditWebState extends State<ButtonCreateEditWeb> {
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
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        fixedSize: MaterialStateProperty.all(
            Size(widget.size.width * .20, widget.size.height * .05)),
        backgroundColor: MaterialStateProperty.all(
          _isLoading ? Colors.grey : const Color(0xFF03132A),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
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
    setState(() {
      _isLoading = false;
    });
    if (value != null) context.pop();
  }
}
