import 'package:formz/formz.dart';

// Define input validation errors
enum UserIdError { empty }

// Extend FormzInput and provide the input type and error type.
class UserId extends FormzInput<int, UserIdError> {
  // Call super.pure to represent an unmodified form input.
  const UserId.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const UserId.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == UserIdError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  UserIdError? validator(int value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty || value.toString() == '0') return UserIdError.empty;

    return null;
  }
}
