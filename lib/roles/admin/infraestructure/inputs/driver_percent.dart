import 'package:formz/formz.dart';

// Define input validation errors
enum DriverPercentError { empty, value }

// Extend FormzInput and provide the input type and error type.
class DriverPercent extends FormzInput<int, DriverPercentError> {
  // Call super.pure to represent an unmodified form input.
  const DriverPercent.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const DriverPercent.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DriverPercentError.empty) return 'El campo es requerido';
    if (displayError == DriverPercentError.value) return 'El campo no puede ser menor a 0';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  DriverPercentError? validator(int value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty) return DriverPercentError.empty;
    if (value < 0 ) return DriverPercentError.value;

    return null;
  }
}
