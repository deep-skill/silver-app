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
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          _isLoading ? Colors.grey : const Color(0xFF03132A),
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

    print("_isLoading ${_isLoading}");
    var value = await widget.onPressedCreateEdit();
    print(value);
    setState(() {
      _isLoading = false;
    });
    if (value != null) context.pop();
  }
}
