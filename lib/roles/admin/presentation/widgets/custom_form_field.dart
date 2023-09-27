import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final bool isTopField;
  final bool isBottomField;
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool? readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final String initialValue;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const CustomFormField({
    super.key,
    this.isTopField = false,
    this.isBottomField = false,
    this.label,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.initialValue = '',
    this.onChanged,
    this.readOnly,
    this.onTap,
    this.onFieldSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(10));

    const borderRadius = Radius.circular(10);

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: isTopField ? borderRadius : Radius.zero,
            topRight: isTopField ? borderRadius : Radius.zero,
            bottomLeft: isBottomField ? borderRadius : Radius.zero,
            bottomRight: isBottomField ? borderRadius : Radius.zero,
          ),
          boxShadow: [
            if (isBottomField)
              BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 5,
                  offset: const Offset(0, 3))
          ]),
      child: TextFormField(
        readOnly: readOnly != null ? true : false,
        onChanged: onChanged,
        onTap: onTap,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, color: Colors.black),
        maxLines: maxLines,
        initialValue: initialValue,
        decoration: InputDecoration(
          floatingLabelBehavior: maxLines > 1
              ? FloatingLabelBehavior.always
              : FloatingLabelBehavior.always,
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder:
              border.copyWith(borderSide: const BorderSide(color: Colors.red)),
          focusedErrorBorder:
              border.copyWith(borderSide: const BorderSide(color: Colors.red)),
          isDense: true,
          label: label != null ? Text(label!) : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
        ),
      ),
    );
  }
}
