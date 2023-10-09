import 'package:formz/formz.dart';

// Define input validation errors
enum StartDateError { empty }

// Extend FormzInput and provide the input type and error type.
class StartDate extends FormzInput<String, StartDateError> {
  // Call super.pure to represent an unmodified form input.
  const StartDate.pure() : super.pure('2023-09-26');

  // Call super.dirty to represent a modified form input.
  const StartDate.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == StartDateError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  StartDateError? validator(String value) {
    if (value.isEmpty  || value.toString().trim().isEmpty || value.toString() == '2023-09-26') return StartDateError.empty;

    return null;
  }
}
