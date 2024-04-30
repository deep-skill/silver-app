import 'package:formz/formz.dart';

// Define input validation errors
enum PriceError { empty, value, format }

// Extend FormzInput and provide the input type and error type.
class Price extends FormzInput<String, PriceError> {
  // Call super.pure to represent an unmodified form input.
  const Price.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Price.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PriceError.empty) return 'El campo es requerido';
    if (displayError == PriceError.format) return 'El campo debe ser un nro.';
    if (displayError == PriceError.value) {
      if (double.tryParse(value)! == 0) return 'El campo no puede ser 0';
      if (double.tryParse(value)! < 0) return 'El campo debe ser positivo';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  PriceError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return PriceError.empty;
    if (double.tryParse(value) == null) return PriceError.format;
    if (double.tryParse(value)! <= 0) return PriceError.value;

    return null;
  }
}
