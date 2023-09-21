import 'package:formz/formz.dart';

// Define input validation errors
enum StartTimeError { empty }

// Extend FormzInput and provide the input type and error type.
class StartTime extends FormzInput<String, StartTimeError> {
  // Call super.pure to represent an unmodified form input.
  const StartTime.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const StartTime.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == StartTimeError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  StartTimeError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return StartTimeError.empty;

    return null;
  }
}
