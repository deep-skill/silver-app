import 'package:formz/formz.dart';

// Define input validation errors
enum CarIdError { empty }

// Extend FormzInput and provide the input type and error type.
class CarId extends FormzInput<int, CarIdError> {
  // Call super.pure to represent an unmodified form input.
  const CarId.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const CarId.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == CarIdError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  CarIdError? validator(int value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty || value == 0) return CarIdError.empty;

    return null;
  }
}