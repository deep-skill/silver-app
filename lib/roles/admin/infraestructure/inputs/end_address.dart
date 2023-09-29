import 'package:formz/formz.dart';

// Define input validation errors
enum EndAddressError { empty }

// Extend FormzInput and provide the input type and error type.
class EndAddress extends FormzInput<String, EndAddressError> {
  // Call super.pure to represent an unmodified form input.
  const EndAddress.pure() : super.pure('Seleccione el punto de destino');

  // Call super.dirty to represent a modified form input.
  const EndAddress.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == EndAddressError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  EndAddressError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty ) return EndAddressError.empty;

    return null;
  }
}
