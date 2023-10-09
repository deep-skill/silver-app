import 'package:formz/formz.dart';

// Define input validation errors
enum StartAddressError { empty }

// Extend FormzInput and provide the input type and error type.
class StartAddress extends FormzInput<String, StartAddressError> {
  // Call super.pure to represent an unmodified form input.
  const StartAddress.pure() : super.pure('Seleccione el punto de recojo');

  // Call super.dirty to represent a modified form input.
  const StartAddress.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == StartAddressError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  StartAddressError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty || value == 'Seleccione el punto de recojo') return StartAddressError.empty;

    return null;
  }
}
