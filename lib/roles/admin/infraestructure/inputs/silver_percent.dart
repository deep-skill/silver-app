import 'package:formz/formz.dart';

// Define input validation errors
enum SilverPercentError { empty, value, format }

// Extend FormzInput and provide the input type and error type.
class SilverPercent extends FormzInput<String, SilverPercentError> {
  // Call super.pure to represent an unmodified form input.
  const SilverPercent.pure() : super.pure('0');

  // Call super.dirty to represent a modified form input.
  const SilverPercent.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == SilverPercentError.format) return 'El campo debe ser un nro.';

    if (displayError == SilverPercentError.value) return '00El campo no puede ser menor a 0';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  SilverPercentError? validator(String value) {
    if (int.tryParse(value) == null) return SilverPercentError.format;
    if (double.tryParse(value)! < 0) return SilverPercentError.value;

    return null;
  }
}