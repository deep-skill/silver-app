import 'package:formz/formz.dart';

// Define input validation errors
enum DriverIdError { empty }

// Extend FormzInput and provide the input type and error type.
class DriverId extends FormzInput<int, DriverIdError> {
  // Call super.pure to represent an unmodified form input.
  const DriverId.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const DriverId.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DriverIdError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  DriverIdError? validator(int value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty || value == 0) return DriverIdError.empty;

    return null;
  }
}
