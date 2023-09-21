import 'package:formz/formz.dart';

// Define input validation errors
enum EnterpriseIdError { empty }

// Extend FormzInput and provide the input type and error type.
class EnterpriseId extends FormzInput<int, EnterpriseIdError> {
  // Call super.pure to represent an unmodified form input.
  const EnterpriseId.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const EnterpriseId.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == EnterpriseIdError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  EnterpriseIdError? validator(int value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty || value.toString() == '0') return EnterpriseIdError.empty;

    return null;
  }
}
